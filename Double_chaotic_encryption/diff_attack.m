%¿¹²î·Ö¹¥»÷·ÖÎö
function [NPCR,UACI]= diff_attack (A,B)
        [m,n] = size(A);
        for i =1:m
            for j =1:n
                if((A(i,j)==B(i,j)))
                    D(i,j)=0;
                else
                    D(i,j)=1;
                end
            end
        end
         diff = A - B;
         NPCR = sum(sum(D))/(m*n);
         UACI = sum(sum(abs(diff)))/(m*n*255);
end