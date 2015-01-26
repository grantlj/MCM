clear
clc
[udata,uitem,uuser]=fun_readFiles('../dataset/u.data','../dataset/u.item','../dataset/joblist.txt','../dataset/u.user');


FilmNum=size(uitem,1);
FilmAverScore=zeros( FilmNum,1 );
FilmTempCounter=zeros( FilmNum,1 );

for i=1:size(udata,1)
   FilmAverScore( udata( i ,2) ) = FilmAverScore( udata( i ,2) )+udata( i ,3);
   FilmTempCounter( udata( i ,2) )=FilmTempCounter( udata( i ,2) )+1;
end

FilmAverScore=FilmAverScore./FilmTempCounter;

UserNum=max(udata(:,1));
UserAverScore=zeros(UserNum,18);

for i=1:size(udata,1)
     UserAverScore( udata(i,1) ,: )=UserAverScore(udata(i,1) ,:) +(udata(i,3)./ FilmAverScore( udata( i ,2) )).* uitem(udata( i ,2),: );
end

 %���й�һ��
 for i=1:size(UserAverScore,1)
     UserAverScore(i,:)=UserAverScore(i,:)./sum(UserAverScore(i,:));

 end

 %��¼�͹۷���
 FilmScore_Preference=zeros(size(uitem));
 %��¼�͹۷�����ÿ��λ�õĿ͹۷���
 FilmWeight=zeros(size(uitem));
 
 %���Ӱ��ÿ������ϵĵ÷�
 for m=1:size(udata,1)
     %user: udata(m,1)
     %film:udata(m,2)
     %score: udata(m,3)
     %�����Ӱ�����item: uitem(udata(m,2),:)
     %����û�����Ȩֵ: UserAverScore(udata(m,1),:)
     FilmScore_Preference(udata(m,2),:)=FilmScore_Preference(udata(m,2),:)+ UserAverScore(udata(m,1),:).*uitem(udata(m,2),:).*udata(m,3);
     FilmWeight(udata(m,2),:)= FilmWeight(udata(m,2),:)+UserAverScore(udata(m,1),:).*uitem(udata(m,2),:);
        
 end
 
FilmScore_Preference=FilmScore_Preference./FilmWeight;
FilmScore_Preference(isnan(FilmScore_Preference))=0;

AgeDimension=6;
OccupationDimension=21;
FilmScore_Age=zeros(FilmNum,AgeDimension);
FilmScore_Occupation=zeros(FilmNum,OccupationDimension);
FilmScore_Age_Counter=zeros(FilmNum,AgeDimension);
FilmScore_Occupation_Counter=zeros(FilmNum,OccupationDimension);

%���水����κ�ְҵ����
for m=1:size(udata,1)
    %user: udata(m,1)
     %film:udata(m,2)
     %score: udata(m,3)
    %age: fun_ageSegmentation(uuser(udata(m,1),2))
    %Occupation:uuser(udata(m,1),3)
    
    %���ȼ��㰴����
    FilmScore_Age_Counter( udata(m,2) ,fun_ageSegmentation(uuser(udata(m,1),2)))=FilmScore_Age_Counter( udata(m,2) ,fun_ageSegmentation(uuser(udata(m,1),2)))+1;
    FilmScore_Age( udata(m,2) ,fun_ageSegmentation(uuser(udata(m,1),2)))=FilmScore_Age( udata(m,2) ,fun_ageSegmentation(uuser(udata(m,1),2)))+udata(m,3);
    %Ȼ����㰴ְҵ
    FilmScore_Occupation_Counter( udata(m,2) ,uuser(udata(m,1),3))=FilmScore_Occupation_Counter( udata(m,2) ,uuser(udata(m,1),3))+1;
    FilmScore_Occupation( udata(m,2) ,uuser(udata(m,1),3))= FilmScore_Occupation( udata(m,2) ,uuser(udata(m,1),3))+udata(m,3);
end

FilmScore_Age=FilmScore_Age./FilmScore_Age_Counter;
FilmScore_Occupation=FilmScore_Occupation./FilmScore_Occupation_Counter;
FilmScore_Age(isnan(FilmScore_Age))=0;
FilmScore_Occupation(isnan(FilmScore_Occupation))=0;

