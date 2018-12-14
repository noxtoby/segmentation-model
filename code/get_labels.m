function [labels,mn,mx] = get_labels(dat,opt)
% FORMAT [labels,mn,mx] = get_labels(dat,opt)
% dat    - Subject's data structure (one subject)
% opt    - Options structure
% labels - {1} Image of labels (in uint8)
%          {2} Confusion matrix
% mn     - Minimum label value
% mx     - Maximum label value
%
% Load image of labels from disk + post-process + get confusion matrix
%__________________________________________________________________________
% Copyright (C) 2018 Wellcome Centre for Human Neuroimaging
mn     = 0;
mx     = 0;
labels = {}; 
if isfield(dat,'label') && opt.gmm.labels.use
           
    if ~opt.gmm.labels.cm.isKey(dat.population)
        return
    else
        ix = opt.gmm.labels.cm(dat.population);
    end        
    
    ix_bg  = max(ix) + 1;
    dm     = dat.label{1}.nii.dat.dim;
    labels = uint8(dat.label{1}.nii.dat(:));
%     figure(666); imshow3D(reshape(labels,dm))
    
    msk          = ismember(labels,ix(ix>0));
    labels(~msk) = ix_bg;
%     figure(666); imshow3D(reshape(msk,dm))
    
    mn = min(labels);
    mx = max(labels);
            
    CM = get_label_cm(dat,opt);
    
    labels = {labels,CM};   
end
%==========================================================================