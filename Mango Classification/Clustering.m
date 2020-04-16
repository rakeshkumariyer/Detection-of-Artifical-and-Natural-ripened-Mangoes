dom_features = matfile('ARnew.mat');   %upload path of matrix file to be clustered
features = [dom_features.r_mat];
%features = features(any(features,2),:);
f = matfile('Ntestnew.mat');
fea = [f.color_mat];
dis = fea(:,4);
count1=1;count2=1;count3=1;count4=1;count5=1;
clu1=[ ];clu2=[ ];clu3= [ ];clu4=[ ];clu5=[ ];
for j =1 :1:size(features)          
% searching for data
    if ((features(j) >=1) && (features(j)<=50))    % checking RGB values
      %c1 =features(j,:); 
      %clu1(count1,:)=c1;
      clu1 = [clu1;features(j) dis(j);];
      count1=count1+1;
   end   
   %clustering data values  
    if ((features(j) >=51) && (features(j)<=100))  
      %c2 =features(j,:); 
      %clu2(count2,:)=c2;
      clu2 = [clu2;features(j) dis(j);];
      count2=count2+1;
    end   

    if ((features(j) >=101) && (features(j)<=144))  
      %c3 =features(j,:);
      %clu3(count3,:)=c3;
      clu3 = [clu3;features(j) dis(j);];
      count3=count3+1;
    end

    if ((features(j) >=145) && (features(j)<=200))  
      %c4 =features(j,:);
      %clu4(count4,:)=c4;
      clu4 = [clu4;features(j) dis(j);];
      count4=count4+1;
    end 
    
    if ((features(j) >=201) && (features(j)<=255))  
      %c5 =features(j,:);
      %clu5(count5,:)=c5;
      clu5 = [clu5;features(j) dis(j);];
     count5=count5+1;
    end
       
end

display(clu1);
display(clu2);
display(clu3);
display(clu4);
display(clu5);
%Save the cluster variables in a matrix
save Clusters\AR.mat clu* -v7.3;
