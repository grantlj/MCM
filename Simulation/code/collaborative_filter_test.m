%For Problem 2: solution method 2, using collaborative filtering tech.
%We use the similarity matrix generated from collaborative filter
%generator.
function [] = collaborative_filter_test()
dataset_path='../dataset/';  
load([dataset_path,'user_simlarity_map.mat']);
 [udata,uitem,~]=fun_readFiles('../dataset/u.data','../dataset/u.item','../dataset/joblist.txt','../dataset/u.user');
 output_path='../out/';
 
 
 fid=fopen([output_path,'t2b.txt'],'w+');
 load([dataset_path,'FilmFeature.mat']);     
 %108,133,228,232,336,338,545,613,696,777
 userlist=[108,133,228,232,336,338,545,613,696,777];  %user's id ready for analysis.
 for i=1:size(userlist,2)
    fprintf(fid,['Userid: ',num2str(userlist(1,i)), ':\n']);
    
    sim_vec=sim_map(userlist(1,i),:);
    tmp_film_vote=zeros(1,size(uitem,1)); tmp_film_count=zeros(1,size(uitem,1));
    for j=1:size(sim_vec,2)
      if (userlist(1,i)==j); continue;end;
      weight=sim_vec(1,j);
      ratelist=udata(find(udata(:,1)==j),:);         %present corr user's vote result.
      tmp_film_vote(1,ratelist(:,2))= tmp_film_vote(1,ratelist(:,2))+weight*ratelist(:,3)';   %weight sum for each film of corr user.
      tmp_film_count(1,ratelist(:,2))=tmp_film_count(1,ratelist(:,2))+1;
    end
    
    tmp_film_vote=tmp_film_vote./tmp_film_count;
    tmp_film_vote=[1:size(uitem,1);tmp_film_vote]';
    
    tmp_film_vote=sortrows(tmp_film_vote,-2);
       for j=1:5
         disp(['Film Id: ',num2str(tmp_film_vote(j,1)),' predicted score:', num2str(tmp_film_vote(j,2))]);
         fprintf(fid,['Film Id: ',num2str(tmp_film_vote(j,1)),' predicted score:', num2str(tmp_film_vote(j,2)),'\n']);
      end
    
 end
 
 fclose(fid);
end

