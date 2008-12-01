/*

    Format converter module using Python.

    Copyright (C) 2007 Marc Poulhiès, marc.poulhies@imag.fr
    Copyright (C) 2005  Robert Lipe, robertlipe@usa.net

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111 USA

 */

#include "defs.h"
#include <ctype.h>

#include <Python.h>

#define MYNAME "pykml"


static char *opt_moteaddr = NULL;
static char *opt_debug = NULL;

// Any arg in this list will appear in command line help and will be 
// populated for you.
// Values for ARGTYPE_xxx can be found in defs.h and are used to 
// select the type of option.
static
arglist_t pykml_args[] = {
  {"wiimote", &opt_moteaddr, "HW address of the wiimote to use",
   "00:1D:BC:3B:2D:C3", ARGTYPE_STRING, ARG_NOMINMAX},
  {"debug", &opt_debug, "Enable debug output in pykml.debug file",
   "0", ARGTYPE_BOOL, ARG_NOMINMAX},

// {"foo", &fooopt, "The text of the foo option in help", 
//   "default", ARGYTPE_STRING, ARG_NOMINMAX} , 
	ARG_TERMINATOR
};

/*******************************************************************************
* %%%        global callbacks called by gpsbabel main process              %%% *
*******************************************************************************/

static int is_rt_tracking = 0;

static void
pykml_rd_init(const char *fname)
{
//	fin = gbfopen(fname, "r", MYNAME);
}

static void 
pykml_rd_deinit(void)
{
//	gbfclose(fin);
}

static void
pykml_read(void)
{
//	your special code to extract waypoint, route and track
//	information from gbfile "fin"
//
// Sample text-file read code:
//	char *s;
//	while ((s = gbfgetstr(fin))) {
//		do_anything(s);
//	}
//
//
// For waypoints:
//         while (have waypoints) {
//                 waypoint = waypt_new()
//                 populate waypoint
//                 waypt_add(waypoint);
//         }
// 
// For routes:
// 
//         route = route_head_alloc();
//         populate struct route_hdr
//	   route_add_head(route);      
//         while (have more routepoints) {
//                 waypoint = waypt_new()
//                 populate waypoint
//                 route_add_wpt(route, waypoint)
//         }
// 
// Tracks are just like routes, except the word "track" replaces "routes".
//
}

static FILE* fout;
static PyObject *pModule;
static PyObject *pTrack;

/*
 *  write Header for output
 */
static void 
pykml_track_hdr(const route_head *header) 
{
  computed_trkdata *td;
  PyObject *pMethod, *pArgs, *pValue;
  track_recompute(header, &td);

  pMethod = PyObject_GetAttrString(pTrack, "setComputedTrackData");

  pArgs = PyTuple_New(12);

  PyTuple_SetItem(pArgs, 0, PyFloat_FromDouble(td->distance_meters));
  PyTuple_SetItem(pArgs, 1, PyFloat_FromDouble(td->max_alt));
  PyTuple_SetItem(pArgs, 2, PyFloat_FromDouble(td->min_alt));
  PyTuple_SetItem(pArgs, 3, PyFloat_FromDouble(td->max_spd));
  PyTuple_SetItem(pArgs, 4, PyFloat_FromDouble(td->min_spd));
  PyTuple_SetItem(pArgs, 5, PyFloat_FromDouble(td->avg_hrt));
  PyTuple_SetItem(pArgs, 6, PyFloat_FromDouble(td->avg_cad));
  PyTuple_SetItem(pArgs, 7, PyLong_FromUnsignedLong(td->start));
  PyTuple_SetItem(pArgs, 8, PyLong_FromUnsignedLong(td->end));
  PyTuple_SetItem(pArgs, 9, PyFloat_FromDouble(td->min_hrt));
  PyTuple_SetItem(pArgs, 10, PyFloat_FromDouble(td->max_hrt));
  PyTuple_SetItem(pArgs, 11, PyFloat_FromDouble(td->max_cad));

  pValue = PyObject_CallObject(pMethod, pArgs);

  Py_DECREF(pValue);
  Py_DECREF(pMethod);
  Py_DECREF(pArgs);
  //  kml_output_header(header, td);

  //  fprintf(fout, "header\n");
}
static void
pykml_add_point_in_py(const waypoint *waypointp)
{
  PyObject *pArgs, *pClass; /* *pValue */
  
  pClass = PyObject_GetAttrString(pTrack, "addPoint");

  pArgs = PyTuple_New(6);

  PyTuple_SetItem(pArgs, 0, PyFloat_FromDouble(waypointp->latitude));
  PyTuple_SetItem(pArgs, 1, PyFloat_FromDouble(waypointp->longitude));
  PyTuple_SetItem(pArgs, 2, PyFloat_FromDouble(waypointp->altitude));
  PyTuple_SetItem(pArgs, 3, PyLong_FromUnsignedLong(waypointp->creation_time));

  if WAYPT_HAS(waypointp, speed)
  {
    PyTuple_SetItem(pArgs, 4, PyFloat_FromDouble(waypointp->speed));
  } else {
    Py_INCREF(Py_None);
    PyTuple_SetItem(pArgs, 4, Py_None);
  }

  if WAYPT_HAS(waypointp, vspeed)
  {
    PyTuple_SetItem(pArgs, 5, PyFloat_FromDouble(waypointp->vspeed)); 
  } else {
    Py_INCREF(Py_None);
    PyTuple_SetItem(pArgs, 5, Py_None);
  }

  PyObject_CallObject(pClass, pArgs);

  Py_DECREF(pArgs);
  //  Py_DECREF(pValue);
  Py_DECREF(pClass);
}

/*
 * called for each point in a track
 */
static void 
pykml_track_disp(const waypoint *waypointp)
{
  pykml_add_point_in_py(waypointp);
}

/*
 * trailer for track writing
 */
static void 
pykml_track_tlr(const route_head *header) 
{
  //  fprintf(fout, "tail\n");
}


static void
pykml_wr_init(const char *fname)
{
  PyObject *pModuleName, *pClass;
  Py_Initialize();

  pModuleName = PyString_FromString("pykml");
  pModule = PyImport_Import(pModuleName);

  Py_DECREF(pModuleName);

  if (pModule == NULL) {
    printf("Error while loading 'pykml' python module."
	   "Check your PYTHONPATH env var !\n");
    exit(-1);
  }

  pClass = PyObject_GetAttrString(pModule, "Track");
  if (is_rt_tracking == 1){
    printf("RT tracking active\n");
    PyObject *pArgs = PyTuple_New(1);
    PyTuple_SetItem(pArgs, 0, Py_True);
    pTrack = PyInstance_New(pClass, pArgs, NULL);
    Py_DECREF(pArgs);
  } else {
    printf("RT tracking not active\n");
    pTrack = PyInstance_New(pClass, NULL, NULL);
  }

  if (pTrack == NULL){
    fprintf(stderr, "Can't instantiate pTrack object!\n");
    exit (-1);
  }
    

  Py_DECREF(pClass);
  fout = xfopen(fname, "w", MYNAME);
  printf("fout open\n");
  
//	fout = gbfopen(fname, "w", MYNAME);
}

/*
 * cleanup after writting
 */
static void
pykml_wr_deinit(void)
{
  printf("wr_deinit\n");
  Py_DECREF(pTrack);
  Py_DECREF(pModule);

  Py_Finalize();
  printf("fout close\n");
  fclose(fout);
//	gbfclose(fout);
}

static char *
pykml_get_and_write_kml(void){
  PyObject *retStr, *pMethod;
  char *str;

  printf("get_and_write\n");
  pMethod = PyObject_GetAttrString(pTrack, "getKML");
  retStr = PyObject_CallObject(pMethod, NULL);
  printf("Calling track.getKML method,..\n");
  fflush(NULL);

  if(retStr == NULL){
    printf("looks like we have a prob\n");
    exit(-1);
  }
  str = PyString_AsString(retStr);

  printf("pykml get andd write before wr!\n");
  fflush(NULL);
  
  fprintf(fout, str);

  Py_DECREF(retStr);
  Py_DECREF(pMethod);
  printf("pykml write finished\n");
  fflush(NULL);

}


/*
 * called when output is to be written
 */
static void
pykml_write(void)
{
// Here is how you register callbacks for all waypoints, routes, tracks.
//  waypt_disp_all(pykml_py_wrap);
//  route_disp_all(pykml_track_hdr, pykml_track_tlr, pykml_track_disp);
  printf("starting write,..\n");
  fflush(NULL);

  /* fills the py track */
  track_disp_all(pykml_track_hdr, pykml_track_tlr, pykml_track_disp);

  pykml_get_and_write_kml();
}

static void
pykml_exit(void)		/* optional */
{
}



/*
 * stuff for RT tracking
 */

static void
pykml_dummy_trkdata(void){
  PyObject *pMethod, *pArgs, *pValue;

  pMethod = PyObject_GetAttrString(pTrack, "setComputedTrackData");

  pArgs = PyTuple_New(12);

  PyTuple_SetItem(pArgs, 0, PyFloat_FromDouble(0));
  PyTuple_SetItem(pArgs, 1, PyFloat_FromDouble(0));
  PyTuple_SetItem(pArgs, 2, PyFloat_FromDouble(0));
  PyTuple_SetItem(pArgs, 3, PyFloat_FromDouble(0));
  PyTuple_SetItem(pArgs, 4, PyFloat_FromDouble(0));
  PyTuple_SetItem(pArgs, 5, PyFloat_FromDouble(0));
  PyTuple_SetItem(pArgs, 6, PyFloat_FromDouble(0));
  PyTuple_SetItem(pArgs, 7, PyLong_FromUnsignedLong(0));
  PyTuple_SetItem(pArgs, 8, PyLong_FromUnsignedLong(0));
  PyTuple_SetItem(pArgs, 9, PyFloat_FromDouble(0));
  PyTuple_SetItem(pArgs, 10, PyFloat_FromDouble(0));
  PyTuple_SetItem(pArgs, 11, PyFloat_FromDouble(0));

  pValue = PyObject_CallObject(pMethod, pArgs);

  Py_DECREF(pValue);
  Py_DECREF(pMethod);
  Py_DECREF(pArgs);
}

static void
pykml_wr_position_init(const char *fname)
{
  is_rt_tracking = 1;
  printf("wr posn init !!\n");
  pykml_wr_init(fname);
}

static void
pykml_wr_position(waypoint *wpt)
{
  printf("wr_position\n");
  pykml_add_point_in_py(wpt);  
}

static void
pykml_wr_position_deinit(void)
{
  //  pykml_dummy_trkdata();
  printf("wr posn deinit, calling write!!\n");
  pykml_get_and_write_kml();
  printf("finish write, deinit now\n");
  fflush(NULL);

  pykml_wr_deinit();
}


/**************************************************************************/

// capabilities below means: we can only read and write waypoints
// please change this depending on your new module 

ff_vecs_t pykml_vecs = {
	ff_type_file,
	FF_CAP_RW_ALL,
	pykml_rd_init,	
	pykml_wr_init,	
	pykml_rd_deinit,	
	pykml_wr_deinit,	
	pykml_read,
	pykml_write,
	pykml_exit,
	pykml_args,
	CET_CHARSET_ASCII, 0,			/* ascii is the expected character set */
						/* not fixed, can be changed through command line parameter */
	{ NULL, NULL, NULL, pykml_wr_position_init, pykml_wr_position, pykml_wr_position_deinit }
};
/**************************************************************************/
