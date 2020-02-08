function [PE, PFA, PMD] = testExperi(FC, FS, trained_ensemble)
% ����ѵ���õķ��������в���
% FC, FS: ��������
%% Testing phase
test_results_cover = ensemble_testing(FC, trained_ensemble);
test_results_stego = ensemble_testing(FS, trained_ensemble);

% Predictions: -1 stands for cover, +1 for stego
false_alarms = sum(test_results_cover.predictions~=-1);
missed_detections = sum(test_results_stego.predictions~=+1);
num_testing_samples = size(FC,1)+size(FS,1);
PFA = false_alarms / size(FC, 1);
PMD = missed_detections / size(FS,1);
PE = (PFA+PMD) / 2;
fprintf('PE: %.4f\n',PE);
end