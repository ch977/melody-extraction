   function pchMfilt=meanPitch(contSet,contTs,nFrame)
        
        ncont=length(contSet);
        sumcont=zeros(nFrame,2);
        sumcont(:,1)=1:nFrame;
        fracontnum=zeros(nFrame,1);         %contour nums of every frame
        sumsal=zeros(nFrame,1);
        for k=1:ncont
            
            fraID=contSet{k}(:,1);
            tem=zeros(nFrame,1);
            tem(fraID)=1;
            fracontnum=fracontnum+tem;
            
            tempcont=zeros(nFrame,2);
            tempcont(fraID,2)=contSet{k}(:,2)*contTs(k);  %pitch*contourSalience
            sumcont=sumcont+tempcont;
            
            tpsa=zeros(nFrame,1);
            tpsa(fraID)=contTs(k);
            sumsal=sumsal+tpsa;
            
        end
        pitchM=sumcont(:,2)./sumsal;   %P(t)
        pitchM(fracontnum==0)=0;
        %mean filter
        %h=fspecial('average',[1,1000]);%2.9 second sliding mean filter
        %pchMfilt=filter(h,1,pitchM);
        pchMfilt=pitchM;
    end