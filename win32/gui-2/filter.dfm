�
 TFRMFILTER 0'  TPF0
TfrmFilter	frmFilterLeft9Top� BorderIconsbiSystemMenu
biMaximize BorderStylebsDialogCaptionFilterClientHeightgClientWidthJColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderPositionpoScreenCenterShowHint	OnCreate
FormCreatePixelsPerInch`
TextHeight 	TGroupBoxgbTracksLeft Top� WidthJHeight� AlignalClientCaption&TracksTabOrder TLabellbTimePlusMinusLefthTop1WidthHeight	AlignmenttaRightJustifyCaptionby  TLabel
lbTimeDaysLeft� Top1Width"HeightCaptionday(s),   TLabellbTimeHoursLeftTop1Width&HeightCaption	hour(s),   TLabellbTimeMinutesLeftrTop1Width-HeightCaption
minute(s),  TLabellbTimeSecondsLeft�Top1Width.HeightCaption	second(s)  	TCheckBoxcbTrackTitleLeftTopWidth\HeightHintTitle for new tracksBiDiModebdLeftToRightCaptionTit&leParentBiDiModeTabOrder OnClickcbTrackTitleClick  TEditedTrackTitleLeftxTopWidth�HeightEnabledTabOrderTextACTIVE LOG # %Y%m%d  	TCheckBoxcbTrackSplitLeftTopxWidth\HeightHint?Split track into several tracks depending on date of trackpointCaption&SplitTabOrder  	TCheckBoxcbTrackTimeLeftTop0WidthQHeightHintShift all tracksCaption&MoveTabOrderOnClickcbTrackTimeClick  TUpDownudTimeHoursLeftTop-WidthHeight	AssociateedTrackTimeHoursMin�Max�Position TabOrderWrap  TEditedTrackTimeHoursLeft� Top-WidthHeightEnabledTabOrderText0  TUpDownudTimeMinutesLeftfTop-WidthHeight	AssociateedTrackTimeMinutesMin Position TabOrderWrap  TEditedTrackTimeMinutesLeftHTop-WidthHeightEnabledTabOrderText0  TEditedTrackTimeDaysLeft� Top-WidthHeightEnabledTabOrderText0  TUpDown
udTimeDaysLeft� Top-WidthHeight	AssociateedTrackTimeDaysMin�Max�Position TabOrderWrap  TEditedTrackTimeSecondsLeft�Top-WidthHeightEnabledTabOrderText0  TUpDownudTimeSecondsLeft�Top-WidthHeight	AssociateedTrackTimeSecondsMin�Max�Position TabOrderWrap  	TCheckBoxcbTrackStartLeftTopHWidth\HeightHint!Take only trackpoints starting atCaptionStart atTabOrderOnClickcbTrackStartClick  TDateTimePickerdtpTrackStartDateLeftxTopFWidthUHeightCalAlignmentdtaLeftDate      ��@Time      ��@
DateFormatdfShortDateMode
dmComboBoxEnabledKinddtkDate
ParseInputTabOrder  TDateTimePickerdtpTrackStartTimeLeft� TopFWidthGHeightCalAlignmentdtaLeftDate      ��@Time      ��@
DateFormatdfShortDateMode
dmComboBoxEnabledKinddtkTime
ParseInputTabOrder	  	TCheckBoxcbTrackStopLeft!TopHWidthNHeight	AlignmenttaLeftJustifyCaptionstop atTabOrder
OnClickcbTrackStopClick  TDateTimePickerdtpTrackStopDateLefttTopFWidthRHeightCalAlignmentdtaLeftDate `����@Time `����@
DateFormatdfShortDateMode
dmComboBoxEnabledKinddtkDate
ParseInputTabOrder  TDateTimePickerdtpTrackStopTimeLeft�TopFWidthGHeightCalAlignmentdtaLeftDate      ��@Time      ��@
DateFormatdfShortDateMode
dmComboBoxEnabledKinddtkTime
ParseInputTabOrder  	TCheckBoxcbTrackPackLeftTop`WidthaHeightHint8Pack all tracks into one track (No duplicate timestamps)Caption
&Pack (or)TabOrderOnClickcbTrackPackClick  	TCheckBoxcbTrackMergeLeftxTop`WidthiHeightHintMerge all tracks into one trackCaptionMergeTabOrderOnClickcbTrackMergeClick   	TGroupBoxgbRoutesLeft TopdWidthJHeightJAlignalTopCaption&Routes && TracksTabOrder TLabellbRouteSimplifyCountLeftpTopWidthHeight	AlignmenttaRightJustifyCaptionlimit toFocusControludRouteSompifyMaxPoints  TLabellbRouteSimplifyTextLeft� TopWidthHeightCaptionPoints  	TCheckBoxcbRouteSimplifyLeftTopWidth\HeightHint6Simplify routes and tracks by limited number of pointsCaptionSimplifyTabOrder OnClickcbRouteSimplifyClick  	TMaskEditedRoutesSimplifyMaxPointsLeft� TopWidth*HeightHint+Upper limit of points for routes and tracksEnabledEditMask999	MaxLengthTabOrderText50   TUpDownudRouteSompifyMaxPointsLeft� TopWidthHeight	AssociateedRoutesSimplifyMaxPointsMinMax�Position2TabOrderWrap  	TCheckBox	cbReverseLeftTop.Width\HeightHintReverse routes and tracksCaptionReverseTabOrder   TPanelpnBottomLeft TopCWidthJHeight$AlignalBottom
BevelOuterbvNoneTabOrder TBitBtnbtnOKLeftyTopWidthcHeightCaptionOKDefault	TabOrder OnClick
btnOKClick
Glyph.Data
�  �  BM�      v   (   $            h                      �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� 333333333333333333  333333333333�33333  334C33333338�33333  33B$3333333�8�3333  34""C33333833�3333  3B""$33333�338�333  4"*""C3338�8�3�333  2"��"C3338�3�333  :*3:"$3338�38�8�33  3�33�"C333�33�3�33  3333:"$3333338�8�3  33333�"C333333�3�3  33333:"$3333338�8�  333333�"C333333�3�  333333:"C3333338�  3333333�#3333333��  3333333:3333333383  333333333333333333  	NumGlyphs  TBitBtn	btnCancelLeft�TopWidthcHeightTabOrderKindbkAbort  TBitBtnBitBtn1LeftTopWidth� HeightCaptionFile based filtersEnabledTabOrder
Glyph.Data
�   �   BM�       v   (               �                     ???  ��� ��� __� //�   � >>� ~~� ��� ���                 wwwwwwwwwwwwwwwww����ww� ���wGp ���{�y� �w��w���v��Gk��{���{ �[���w�w����w��w�����z�{�����ww[�����ww������Wt�������{���   	TGroupBoxgbWaypointsLeft Top WidthJHeightdAlignalTopCaption
&WaypointsColor	clBtnFaceParentColorTabOrder  TImageImage1Left8Top0WidthHeightPicture.Data
  TBitmap�   BM�       v   (               �                     ???  ��� ��� __� //�   � >>� ~~� ��� ���                 wwwwwwwwwwwwwwwww����ww� ���wGp ���{�y� �w��w���v��Gk��{���{ �[���w�w����w��w�����z�{�����ww[�����ww������Wt�������{���Stretch	  	TCheckBoxcbWayptMergeDupLocLeft� TopWidthqHeightHint(Merge waypoints with duplicate locationsCaption	locationsEnabledTabOrder  	TCheckBoxcbWayptMergeDupNamesLeft� TopWidthmHeightHint+Merge waypoints with duplicate "short name"Caption"short names"EnabledTabOrder  	TCheckBoxcbWayptMergeDistanceLeftTop0WidthyHeightHint&Merge waypoints separated by less thenCaptionRadiusEnabledTabOrderOnClickcbWayptMergeDistanceClick  	TComboBoxcobWayptMergeDistLeft� Top.WidthYHeightStylecsDropDownListEnabled
ItemHeightItems.StringsFeetMiles TabOrder  TEditedWayptMergeDistLeft� Top.WidthQHeightEnabledTabOrderText1  	TCheckBoxcbWayptSortLeftTopJWidth� HeightHint0Sort waypoints by "short name" or by descriptionCaptionSortTabOrder  	TCheckBoxcbWayptMergeDupsLeftTopWidthqHeightHintMerge duplicate waypointsCaptionDuplicatatesTabOrder OnClickcbWayptMergeDupsClick    