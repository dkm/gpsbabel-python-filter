# Format converter module using Python.

# Copyright (C) 2007 Marc Poulhiès, marc.poulhies@imag.fr

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111 USA

import xml.etree.ElementTree as ET # python 2.5

import cStringIO

class ComputedTrkData:
    def __init__(self, distance_meters, max_alt, min_alt, max_speed, min_speed,
                 avg_hrt, avg_cad, start, end, min_hrt, max_hrt, max_cad):
        
        self.distance_meters = distance_meters
        self.max_alt = max_alt
        self.min_alt = min_alt
        self.max_speed = max_speed
        self.min_speed = min_speed
        self.avg_hrt = avg_hrt
        self.avg_cad = avg_cad
        self.start = start
        self.end = end
        self.min_hrt = min_hrt
        self.max_hrt = max_hrt
        self.max_cad = max_cad


class Waypoint:
    def __init__(self, lat, longi, alt, creat, speed, vspeed):
        self.lat = lat
        self.longi = longi
        self.alt = alt
        self.creat = creat
        self.speed = speed
        self.vspeed = vspeed
        print self.lat, self.longi, self.alt, self.creat, self.speed, self.vspeed

class Track:
    def __init__(self):
        self.waypts=[]
        self.trkdata = None

        self.max_speed_wpt = None
        self.max_vz_wpt = None
        self.min_vz_wpt = None

        self.max_alt_wpt = None
        
    def addPoint(self, lat, long, alt, creat, speed, vspeed):
        wp = Waypoint(lat, long, alt, creat, speed, vspeed)
        self.waypts.append(wp)

        if speed != None and (self.max_speed_wpt == None or self.max_speed_wpt.speed <= speed):
            self.max_speed_wpt = wp

        if vspeed != None and (self.max_vz_wpt == None or self.max_vz_wpt.vspeed <= vspeed):
            self.max_vz_wpt = wp

        if vspeed != None and (self.min_vz_wpt == None or self.min_vz_wpt.vspeed >= vspeed):
            print "min speed = ", vspeed
            self.min_vz_wpt = wp

        if alt != None and (self.max_alt_wpt == None or self.max_alt_wpt.alt <= alt):
            self.max_alt_wpt = wp
    
    def addWaypoint(self, waypt):
        self.waypts.append(waypt)
        

    def setComputedTrackData(self,distance_meters, max_alt, min_alt, max_speed, min_speed,
                 avg_hrt, avg_cad, start, end, min_hrt, max_hrt, max_cad):
        
        self.trkdata = ComputedTrkData(distance_meters, max_alt,
                 min_alt, max_speed, min_speed, avg_hrt, avg_cad,
                 start, end, min_hrt, max_hrt, max_cad)


    def addFlightInfo(self, node):
        node = ET.SubElement(node, "Folder")

        ET.SubElement(node, "name").text = "Flight info"
        ET.SubElement(node, "description").text = "Displays informations about flight"

        pm = ET.SubElement(node, "Placemark")
        ET.SubElement(pm, "name").text = "Maximum altitude : %d m" %int(self.max_alt_wpt.alt)
        p = ET.SubElement(pm, "Point")
        ET.SubElement(p, "altitudeMode").text = "absolute"
        ET.SubElement(p, "extrude").text = "1"
        ET.SubElement(p, "coordinates").text = "%f,%f,%f" %(self.max_alt_wpt.longi,
                                                            self.max_alt_wpt.lat,
                                                            self.max_alt_wpt.alt)


        pm = ET.SubElement(node, "Placemark")
        ET.SubElement(pm, "name").text = "Maximum speed : %d km/h" %int(self.max_speed_wpt.speed*3.6)
        p = ET.SubElement(pm, "Point")
        ET.SubElement(p, "altitudeMode").text = "absolute"
        ET.SubElement(p, "extrude").text = "1"
        ET.SubElement(p, "coordinates").text = "%f,%f,%f" %(self.max_speed_wpt.longi,
                                                            self.max_speed_wpt.lat,
                                                            self.max_speed_wpt.alt)


        pm = ET.SubElement(node, "Placemark")
        ET.SubElement(pm, "name").text = "Maximum Vz : %d m/s" %int(self.max_vz_wpt.vspeed)
        p = ET.SubElement(pm, "Point")
        ET.SubElement(p, "altitudeMode").text = "absolute"
        ET.SubElement(p, "extrude").text = "1"
        ET.SubElement(p, "coordinates").text = "%f,%f,%f" %(self.max_vz_wpt.longi,
                                                            self.max_vz_wpt.lat,
                                                            self.max_vz_wpt.alt)

        pm = ET.SubElement(node, "Placemark")
        ET.SubElement(pm, "name").text = "Minimum Vz : %d m/s" %int(self.min_vz_wpt.vspeed)
        p = ET.SubElement(pm, "Point")
        ET.SubElement(p, "altitudeMode").text = "absolute"
        ET.SubElement(p, "extrude").text = "1"
        ET.SubElement(p, "coordinates").text = "%f,%f,%f" %(self.min_vz_wpt.longi,
                                                            self.min_vz_wpt.lat,
                                                            self.min_vz_wpt.alt)

    def getKML(self):
        sio = cStringIO.StringIO()

        sio.write('<?xml version="1.0" encoding="UTF-8"?>\n')
        kmlroot = ET.Element("kml", {'xmlns':'http://earth.google.com/kml/2.1'})

        folder = ET.SubElement(kmlroot, "Folder")
        ET.SubElement(folder, "name").text = "Test PyKML module"
        ET.SubElement(folder, "description").text = "Sample descro"


        self.addFlightInfo(folder)

        folder = ET.SubElement(folder, "Folder")
        ET.SubElement(folder, "name").text = "Simple track"
        ET.SubElement(folder, "description").text = "Shows the flight"

        prev = self.waypts[0]
        for next in self.waypts[1:]:
            pm = ET.SubElement(folder, "Placemark")

            ET.SubElement(pm, "name").text = "sample placemark"
        
            style = ET.SubElement(pm, "Style")
            ET.SubElement(style, "color").text = "FF001EFF"
            ET.SubElement(style, "width").text = "2"

            ls = ET.SubElement(pm, "LineString")
            ET.SubElement(ls, "tessellate").text = "1"
            ET.SubElement(ls, "altitudeMode").text = "absolute"

            ET.SubElement(ls, "coordinates").text = "%f,%f,%f %f,%f,%f" %(next.longi, next.lat, next.alt,
                                                                          prev.longi, prev.lat, prev.alt)

            prev = next


        tree = ET.ElementTree(kmlroot)
        tree.write(sio)

        return sio.getvalue()

