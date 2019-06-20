% Data Analysis for Lydia Model
[data1 header1] = ReadSegy('./Cropped_GoCad_Seismic/ndhseis_t02.segy');
[data2 header2] = ReadSegy('./Cropped_GoCad_Seismic/ndhseis_t00.segy');
[data3 header3] = ReadSegy('./Cropped_GoCad_Seismic/ndhseis_tshift_iphase.segy');
[data4 header4] = ReadSegy('./Cropped_GoCad_Seismic/ndhseis_tshift_traditional.segy');



%% Real Data Analysis
[data1 header1] = ReadSegy('./Agbami_OBN_PSDM/Base5-50.segy');
[data2 header2] = ReadSegy('./Agbami_OBN_PSDM/Mon5-50.segy');
[data3 header3] = ReadSegy('./Agbami_OBN_PSDM/tshift_phase.segy');
[data4 header4] = ReadSegy('./Agbami_OBN_PSDM/tshift_amp.segy');



%% Use the QC Ui
QC_ui(data1,header1,[1 2 1300],data2,header2,data3,header3,data4,header4)


