%For Problem 2: concate person's feture and movie feature together,
%using Classification and Regression Tree model to construct a regreeeion
%predictor.
function [] = c_rt_generator()
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
              get_user_job_info(rate_rec_tmp(1),uuser),...                                                    %user-rate_rec_tmp(2)ob info.
              FilmScore_Age(rate_rec_tmp(2),:),...                                                            %film-age score.
              FilmScore_Occupation(rate_rec_tmp(2),:)];                                                       %film-occupation socre.
    
     %film's final score.
    
     score(i,:)=rate_rec_tmp(3);
      feat(i,:)=feat_tmp;
  end
  
%construct c_rt tree.
model=fitrtree(feat(1:60000,:),score(1:60000,:));
%view(rtree);
save([dataset_path,'c_rt_model.mat'],'model');
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


