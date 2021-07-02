function varargout = psinsguide(varargin)
% PSINSGUIDE MATLAB code for psinsguide.fig. DO NOT EDIT!!!
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @psinsguide_OpeningFcn, ...
                   'gui_OutputFcn',  @psinsguide_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
function psinsguide_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
movegui(gcf,'center');
set(handles.sinsgps153,'value',1);
global gmsource
gmsource = handles.msource;
function varargout = psinsguide_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
%----------------------------------------------------------------------
function opru(mfile)
global gmsource
if get(gmsource,'Value')==1, open(mfile); else run(mfile); end
function msource_Callback(hObject, eventdata, handles)
global gmsource
gmsource = hObject;
return;
function psinsinit_Callback(hObject, eventdata, handles)
opru('psinsinit.m');
function conedemo_Callback(hObject, eventdata, handles)
opru('demo_cone_motion.m');
function sculldemo_Callback(hObject, eventdata, handles)
opru('demo_scull_motion.m');
function rotordemo_Callback(hObject, eventdata, handles)
opru('demo_gyro_rotor_precession.m');
function sagnacdemo_Callback(hObject, eventdata, handles)
opru('demo_sagnac_effect.m');
function randonmwalk_Callback(hObject, eventdata, handles)
opru('demo_drift_random_walk.m');
function transfertrj_Callback(hObject, eventdata, handles)
opru('test_align_transfer_trj.m');
function transferimu_Callback(hObject, eventdata, handles)
opru('test_align_transfer_imu_simu.m');
function transferalign_Callback(hObject, eventdata, handles)
opru('test_align_transfer.m');
function cartrj_Callback(hObject, eventdata, handles)
opru('test_SINS_trj.m');
function sins_Callback(hObject, eventdata, handles)
opru('test_SINS.m');
function dr_Callback(hObject, eventdata, handles)
opru('test_DR.m');
function sinsdr_Callback(hObject, eventdata, handles)
opru('test_SINS_DR.m');;
function sinsgps153_Callback(hObject, eventdata, handles)
set(handles.sinsgps153,'value',1); set(handles.sinsgps186,'value',0); set(handles.sinsgps193,'value',0);
function sinsgps186_Callback(hObject, eventdata, handles)
set(handles.sinsgps153,'value',0); set(handles.sinsgps186,'value',1); set(handles.sinsgps193,'value',0);
function sinsgps193_Callback(hObject, eventdata, handles)
set(handles.sinsgps153,'value',0); set(handles.sinsgps186,'value',0); set(handles.sinsgps193,'value',1);
function sinsgps_Callback(hObject, eventdata, handles)
if get(handles.sinsgps153,'value')
    opru('test_SINS_GPS_153.m');
elseif get(handles.sinsgps186,'value')
    opru('test_SINS_GPS_186.m');
else
    opru('test_SINS_GPS_193.m');
end
function alignsimulate_Callback(hObject, eventdata, handles)
opru('test_align_methods_compare.m');
function alignrealdata_Callback(hObject, eventdata, handles)
opru('test_align_methods_compare_lgimu.m');
function twoposition_Callback(hObject, eventdata, handles)
opru('test_align_two_position.m');
function alignrotation_Callback(hObject, eventdata, handles)
opru('test_align_rotation.m');
function alignekf_Callback(hObject, eventdata, handles)
opru('test_align_ekf.m');
function alignukf_Callback(hObject, eventdata, handles)
opru('test_align_ukf.m');
function sysclbt_Callback(hObject, eventdata, handles)
opru('test_system_calibration.m');
function attcompare_Callback(hObject, eventdata, handles)
opru('test_attitude_update_methods_compare.m');
function sinsstatic_Callback(hObject, eventdata, handles)
opru('test_SINS_static.m');
function coneclassic_Callback(hObject, eventdata, handles)
opru('demo_cone_error.m');
function ahrsmahony_Callback(hObject, eventdata, handles)
opru('test_AHRS_Mahony.m');
function ahrsqekf_Callback(hObject, eventdata, handles)
opru('test_AHRS_QEKF.m');
function postrj_Callback(hObject, eventdata, handles)
opru('test_POS_trj.m');
function posfusion_Callback(hObject, eventdata, handles)
opru('test_POS_fusion.m');


