% load a image from the vessel-12 dataset

dir = 'D:\Desktop\vessel12\tar_bz2_per_1';
patient_num = 1;

I = double(mha_read_volume(sprintf('%s\\VESSEL12_%02d\\VESSEL12_%02d.mhd',dir,patient_num,patient_num)));

% load a mask from the vessel-12 dataset

dir_mask = 'D:\Backup\Desktop\vessel12\lungmasks\VESSEL12_01-20_Lungmasks';
patient_num = 1;

M = double(mha_read_volume(sprintf('%s\\VESSEL12_%02d.mhd',dir_mask,patient_num)));


% Permute the data because mha data are stored as row major, whereas Matlab is column major
I = permute(double(I),[2 1 3]);
M = permute(double(M),[2 1 3]);

% Mask out Image area by binary mask
I = I .* M;
%normalize input a little bit
I = I - min(I(:));
I = I / prctile(I(I(:) > 0.5 * max(I(:))),90);
I(I>1) = 1;

% compute enhancement for two different tau values
V = vesselness3D(I, 0.9:0.7:3, [1;1;1], 1, true);

% display result
figure; 
subplot(1,2,1)
% maximum intensity projection
imshow(flipud(squeeze( max(I,[],1))'))
title('MIP of the input image')
axis image

subplot(1,2,2)
% maximum intensity projection
imshow(flipud(squeeze(max(V,[],1))'))
title('MIP of the filter enhancement (tau=0.75)')
axis image
