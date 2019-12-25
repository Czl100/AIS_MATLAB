function [PE,bestLearner]=getBestLearner(learners, FC, FS)
% ��ȡ�����׼ȷ���Ӽ����
PE = zeros(length(learners),1,'single');
for i = 1:length(learners)
  %% ��cover����ͶƱ
  proj = FC(:,learners{i}.subspace) * learners{i}.w - learners{i}.b;
  votes = sign(proj);
  % resolve ties randomly
  votes(votes==0) = rand(sum(votes==0),1)-0.5;
  % form final predictions
  test_results_cover.predictions = sign(votes);
  % output also the sum of the individual votes (~confidence info)
  test_results_cover.votes = votes;
  %% ��stego����ͶƱ
  proj = FS(:,learners{i}.subspace) * learners{i}.w - learners{i}.b;
  votes = sign(proj);
  % resolve ties randomly
  votes(votes==0) = rand(sum(votes==0),1)-0.5;
  % form final predictions
  test_results_stego.predictions = sign(votes);
  % output also the sum of the individual votes (~confidence info)
  test_results_stego.votes = votes;
  %% ����learner�Ĵ�����
  % Predictions: -1 stands for cover, +1 for stego
  false_alarms = sum(test_results_cover.predictions~=-1);
  missed_detections = sum(test_results_stego.predictions~=+1);
  num_testing_samples = size(FC,1)+size(FS,1);
  PFA = false_alarms / size(FC, 1);
  PMD = missed_detections / size(FS, 1);
  PE(i) = (PFA+PMD) / 2;
  PE(i) = round(PE(i),3); PFA=round(PFA,3); PMD=round(PMD,3);
end
ind=PE==min(PE);
bestLearner=learners{ind};