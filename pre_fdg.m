clearvars;
%% Path setting
ROOT = 'D:/Workspaces/matlab_scripts/sub0001&sub0002/';
rawSrcRootPath = [ROOT, 'dicom/'];

%% Dicom to Nifti
rawSubs = dir(rawSrcRootPath);
rawSubs = rawSubs(3:end);
niftiRootPath = fullfile(ROOT, 'nifti');
for i = 1:numel(rawSubs)
    niftiSub = fullfile(niftiRootPath, rawSubs(i).name);
    mkdir(niftiSub);
    
    spm_jobman('initcfg');
    
    matlabbatch{1}.spm.util.import.dicom.data = cellfun(@(j)fullfile(rawSrcRootPath, rawSubs(i).name, j), cellstr(spm_select('list',[rawSrcRootPath, rawSubs(i).name,'/',],'.IMA')), 'UniformOutput', false);
    matlabbatch{1}.spm.util.import.dicom.root = 'flat';
    matlabbatch{1}.spm.util.import.dicom.outdir = {niftiSub};
    matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
    matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
    matlabbatch{1}.spm.util.import.dicom.convopts.meta = 0;
    matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
    
    spm_jobman('run', matlabbatch);
    clear matlabbatch;
end;

% 
% %% Set the origin to the center of the image
% % This part is written by Fumio Yamashita.
% % Modify by sangf.
% niftiSubs = dir(niftiRootPath);
% niftiSubs = niftiSubs(3:end);
% for i = 1:numel(niftiSubs)
%     niftiSub = dir(fullfile(niftiRootPath, niftiSubs(i).name, '*.nii'));
%     for j = 1:numel(niftiSub)
%         % disp(fullfile(niftiRootPath, niftiSubs(i).name, niftiSub(j).name))
%         st.vol = spm_vol(fullfile(niftiRootPath, niftiSubs(i).name, niftiSub(j).name));
%         vs = st.vol.mat\eye(4);
%         vs(1:3,4) = (st.vol.dim+1)/2;
%         spm_get_space(st.vol.fname,inv(vs));
%     end;
% end;
% 
% %% Normalize & Smooth
% for i = 1:numel(niftiSubs)
%     niftiSub = dir(fullfile(niftiRootPath, niftiSubs(i).name, '*.nii'));
%     for j = 1:numel(niftiSub)
%         spm_jobman('initcfg');
%         matlabbatch = {};
%         
%         disp(fullfile(niftiRootPath, niftiSubs(i).name, niftiSub(j).name))
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.source = {fullfile(niftiRootPath, niftiSubs(i).name, niftiSub(j).name)};
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.wtsrc = '';
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.resample = {fullfile(niftiRootPath, niftiSubs(i).name, niftiSub(j).name)};
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.template = {'D:\Program Files\MATLAB\R2016b\toolbox\spm12\toolbox\OldNorm\PET.nii,1'};
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.weight = '';
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.smosrc = 8;
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.smoref = 0;
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.regtype = 'mni';
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.cutoff = 25;
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.nits = 16;
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.reg = 1;
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.preserve = 0;
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.bb = [-78 -112 -70
%                                                                 78 76 85];
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.vox = [2 2 2];
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.interp = 1;
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.wrap = [0 0 0];
%         matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.prefix = 'norm_';
%         
%         spm_jobman('run',matlabbatch);
%         clear matlabbatch;
%         
%         spm_jobman('initcfg');
%         matlabbatch = {};
%         
%         matlabbatch{1}.spm.spatial.smooth.data = {fullfile(niftiRootPath, niftiSubs(i).name, ['norm_', niftiSub(j).name])};
%         matlabbatch{1}.spm.spatial.smooth.fwhm = [10 10 10];
%         matlabbatch{1}.spm.spatial.smooth.dtype = 0;
%         matlabbatch{1}.spm.spatial.smooth.im = 0;
%         matlabbatch{1}.spm.spatial.smooth.prefix = 'smth_';
%         
%         spm_jobman('run',matlabbatch);
%         clear matlabbatch;
%     end;
%     
%     smoothSub = fullfile(ROOT, 'smooth', niftiSubs(i).name);
%     mkdir(smoothSub);
%     movefile(fullfile(niftiRootPath, niftiSubs(i).name, 'smth_*'), smoothSub);
%     
%     normSub = fullfile(ROOT, 'norm', niftiSubs(i).name);
%     mkdir(normSub);
%     movefile(fullfile(niftiRootPath, niftiSubs(i).name, 'norm_*'), normSub);
%     movefile(fullfile(niftiRootPath, niftiSubs(i).name, '*.mat'), normSub);
% end;
