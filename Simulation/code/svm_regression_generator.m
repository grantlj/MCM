%For Problem 2: concate person's feture and movie feature together,
%using svm regression model(libsvm) to automaticly calculate the weight.
function [] = svm_regression_generator()
  try
      addpath(genpath('libsvm-3.18/'));
  catch
  end
  
  dataset_path='../dataset/';
  %cd(dataset_path);
  load([dataset_path,'FilmFeature.mat']);                                                                          %load film info.
  load([dataset_path,'UserFeature.mat']);                                                                          %load film preference info.
  [udata,uitem,uuser]=fun_readFiles('../dataset/u.data','../dataset/u.item','../dataset/joblist.txt','../dataset/u.user');  %load user info.
  
  feat=zeros(size(udata,1),72);score=[];  %the svm regression feature and corresponding output score.
  for i=1:size(udata,1)
    rate_rec_tmp=udata(i,:);
    %disp(num2str(rate_rec_tmp(3)));
%     feat_tmp=[UserAverScore(rate_rec_tmp(1),:),  ...                                          %user-preference info.
%               get_user_age_info(rate_rec_tmp(1),uuser),...                                    %user-age info.
%               get_user_job_info(rate_rec_tmp(1),uuser),...                                    %user-job info.
%               FilmScore_Preference(rate_rec_tmp(2),:),...                                      %film-preference score.
%               FilmScore_Age(rate_rec_tmp(2),:),...                                            %film-age score.
%               FilmScore_Occupation(rate_rec_tmp(2),:)];                                       %film-occupation socre.
  
%improved version: fusion user-preference and
  %film-preference:
 feat_tmp=[get_fusion_feat(UserAverScore(rate_rec_tmp(1),:),FilmScore_Preference(rate_rec_tmp(2),:)),  ...    %user-preference info.
              get_user_age_info(rate_rec_tmp(1),uuser),...                                                    %user-age info.
              get_user_job_info(rate_rec_tmp(1),uuser),...                                                %user-rate_rec_tmp(2)ob info.
              FilmScore_Age(rate_rec_tmp(2),:),...                                                        %film-age score.
              FilmScore_Occupation(rate_rec_tmp(2),:)];                                                   %film-occupation socre.
    
     %film's final score.
    
     score(i,:)=rate_rec_tmp(3);
      feat(i,:)=feat_tmp;
  end
  
% GA Algorithm to search for bestc and best g for svm regression model. 
ga_option.maxgen = 100;
ga_option.sizepop = 20; 
ga_option.pCrossover = 0.4;
ga_option.pMutation = 0.01;
ga_option.cbound = [0.1,100];
ga_option.gbound = [0.01,100];
ga_option.v = 3;
[bestCVmse,bestc,bestg,ga_option] = gaSVMcgForRegress(score(1:60000,:),feat(1:60000,:),ga_option);   

  cmd = [' -s 3 -p 0.4 -h 0 -c ',num2str(bestc),' -g ',num2str(bestg)];                               %using best param to train svm regression.
 % cmd = ['-s 3 -p 0.4 -h 0'];
 % cmd=[' '];
  model = svmtrain(score(1:60000,:), feat(1:60000,:), cmd);        
  
  save([dataset_path,'svm_regression_model.mat'],'model');
  
  [predict,accuracy,decision_value] = svmpredict(score(60000:100000,:),feat(60000:100000,:),model);   %using 60000-100000 record as cross-validation.
  predict=round(predict);
  compare=[predict,score(60000:100000)];
  
  right=0;
  for i=1:size(compare,1)
     if (compare(i,1)==compare(i,2))
         right=right+1;
     end
  end
  
  disp(num2str(right/size(compare,1)));
end

function [age_feat]=get_user_age_info(userid,uuser)
 age_feat=zeros(1,6);
 age_feat(1,fun_ageSegmentation(uuser(userid,2)))=1;
 %age_feat=uuser(userid,2);
end

function [job_feat]=get_user_job_info(userid,uuser)
  job_feat=zeros(1,21);
  job_feat(1,uuser(userid,3))=1;
end

function [fusion_feat]=get_fusion_feat(user_pre,film_pre)
  fusion_feat=user_pre.*film_pre./(max(user_pre)*max(film_pre));

  for i=1:size(fusion_feat,2)
    if (isnan(fusion_feat(1,i)))
        fusion_feat(1,i)=0;
    end
   end


end


