predictPoint=200
%borrow yesterday's and today's value 
x=linspace((point+1),point+predictPoint+1,predictPoint+1);
output2(1,1)=y(point-1);
output2(2,1)=y(point);
for i=3:predictPoint+2
    testh1(i)=output2(i-2);
    testh2(i)=output2(i-1);
     %IFpart(Rule)
            j1=1;
            for number=1:PrePara/4
                termSet{1}(number)={[swarm(gBest).Position(j1:j1+1)]};
                j1=j1+2;
            end
            for number=1:PrePara/4
                termSet{2}(number)={swarm(gBest).Position(j1:j1+1)};
                j1=j1+2;
            end
            beta=[];
            for rule=1:length(formationMatrix)
                beta(rule,i)=gaussmf(testh1(i),termSet{1}{formationMatrix(rule,1)})*gaussmf(testh2(i),termSet{2}{formationMatrix(rule,2)});
            end    

        %new_yHead(output)
        for rule=1:length(formationMatrix)
            g(rule)=sum(beta(rule,:))/sum(beta(:));
        end
         for jj=3:predictPoint+1
             TMP1=[];
             for k=1:length(formationMatrix)
                 TMP=[g(k) g(k)*output2(jj-2) g(k)*output2(jj-1)];
                 TMP1=[TMP1 TMP];
             end
             A(jj,:)=TMP1;
             output2(jj,1)=A(jj,:)*swarm(gBest).RLSE.theta;  %y
         end
         for jj=1:testPoint
             PSO.test.e(jj)=(y(jj+point-1)-output2(jj,1))^2;
         end
             PSO.test.rmse=sqrt(sum(PSO.test.e)/(testPoint))
        
end

%         for jj=1:testPoint
%             %IFpart(Rule)
%             j1=1;
%             for number=1:PrePara/4
%                 termSet{1}(number)={[swarm(gBest).Position(j1:j1+1)]};
%                 j1=j1+2;
%             end
%             for number=1:PrePara/4
%                 termSet{2}(number)={swarm(gBest).Position(j1:j1+1)};
%                 j1=j1+2;
%             end
%             beta=[];
%             for rule=1:length(formationMatrix)
%                 beta(rule,i)=gaussmf(testh1,termSet{1}{formationMatrix(rule,1)})*gaussmf(testh2,termSet{2}{formationMatrix(rule,2)});
%             end
%         end
%         
%         %new_yHead(output)
%         for rule=1:length(formationMatrix)
%             g(rule)=sum(beta(rule,:))/sum(beta(:));
%         end
%         for jj=1:testPoint
%             TMP1=[];
%             for k=1:length(formationMatrix)
%                 TMP=[g(k) g(k)*y(point+jj-1) g(k)*y(point+jj)];
%                 TMP1=[TMP1 TMP];
%             end
%             A(jj,:)=TMP1;
%             output2(jj,1)=A(jj,:)*swarm(gBest).RLSE.theta;  %y
%         end
%         for jj=1:testPoint
%             PSO.test.e(jj)=(y(jj+point-1)-output2(jj,1))^2;
%         end
%             PSO.test.rmse=sqrt(sum(PSO.test.e)/(testPoint))
        plot(x,output2,'r--');