%For Problem 2: concate person's feture and movie feature together,
%using Classification and Regression Tree model generated from
%c_rt_test to calculate each user's potential interesting
%films.
function c_rt_test()
%108,133,228,232,336,338,545,613,696,777
  try
      addpath(genpath('libsvm-3.18/'));
  catch
  end
  dataset_path='../dataset/';
  output_path='../out/';
  fid=fopen([output_path,'t2c.txt'],'w+');
  
  load([dataset_path,'FilmFeature.mat']);                                                                          %load film info.
  load([dataset_path,'UserFeature.mat']);    
  [udata,uitem,uuser]=fun_readFiles('../dataset/u.data','../dataset/u.item','../dataset/joblist.txt','../dataset/u.user');
  load([dataset_path,'c_rt_model.mat']);                          %load svm regression model.
  
  userlist=[108,133,228,232,336,338,545,613,696,777];  %user's id ready for analysis.
  for i=1:size(userlist,2)   
      fprintf(fid,['Userid: ',num2str(userlist(1,i)), ':\n']);
      predict_score=zeros(size(uitem,1),2);
      for j=1:size(uitem,1)    %select film from film db and concate as a feature vector.
          predict_score(j,1)=j;
%            feat_tmp=[UserAverScore(userlist(1,i),:),  ...                                   %user-preference info.
%               get_user_age_info(userlist(1,i),uuser),...                                    %user-age info.
%               get_user_job_info(userlist(1,i),uuser),...                                    %user-job info.
%               FilmScore_Preference(j,:),...                                                 %film-preference score
%               FilmScore_Age(j,:),...                                                        %film-age score.
%               FilmScore_Occupation(j,:)];                                                   %film-occupation socre.
%               [predict,accuracy,decision_value] = svmpredict(3,feat_tmp,model); 

              %improved version: fusion user-preference and
              %film-preference:
              a=get_fusion_feat(UserAverScore(userlist(1,i),:),FilmScore_Preference(j,:));
              feat_tmp=[a,...                                                               %user-preference info.
              get_user_age_info(userlist(1,i),uuser),...                                    %user-age info.
              get_user_job_info(userlist(1,i),uuser),...                                    %user-job info.
              FilmScore_Age(j,:),...                                                        %film-age score.
              FilmScore_Occupation(j,:)];                                                   %film-occupation socre.
              predictscore=predict(model,feat_tmp);
              predict_score(j,2)=predictscore;
      end
      
    predict_score=sortrows(predict_score,-2);                    %descent sort by column 2, the predict score.
      for j=1:5
         disp(['Film Id: ',num2str(predict_score(j,1))]);
         fprintf(fid,['Film Id: ',num2str(predict_score(j,1)),'\n']);
      end
  end
  
  fclose(fid);
  
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
