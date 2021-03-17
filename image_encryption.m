classdef image_encryption
      properties   %���������
         plaintext_img        %����ͼ��
%          ciphertext_img    %����ͼ��
         m          %����
	     n          %���� 
         chaos_sequence     %��������
      end   
     
      methods
        function obj = image_encryption(img,m,n,chaos_sequence)
	        obj.plaintext_img = img;
%             obj.ciphertext_img = img2;
	        obj.m = m;
	        obj.n = n;
            obj.chaos_sequence = chaos_sequence; 
        end
        
         %ͼ�����
         function [blur_img]=encryption(obj)
                N0 = obj.m * obj.n / 2;
                N = obj.m * obj.n;
                for i = 1 : N0
                    k1(2*i -1) = (obj.chaos_sequence(i,1) - floor(obj.chaos_sequence(i,1)))*1e5;
                    k1(2*i) = (obj.chaos_sequence(i,2) - floor(obj.chaos_sequence(i,2)))*1e5;
                    k2(2*i -1) = mod(round((obj.chaos_sequence(i,3) - floor(obj.chaos_sequence(i,3)))*1e14),256);
                    k2(2*i) = mod(round((obj.chaos_sequence(i,4) - floor(obj.chaos_sequence(i,4)))*1e14),256);
                end

                [k1_new,Ik1] = sort(k1);        %����k1�������е���������

                S = reshape(obj.plaintext_img,N,1);

                for i = 1:N
                    B(i) = S(Ik1(i));
                end
               
                BS = dec2bin(B);          %ʮ������ת������
                C = BS;
                C(:,1) = BS(:,5);
                C(:,5) = BS(:,1);
                C(:,3) = BS(:,7);
                C(:,7) = BS(:,3);
                SS = bin2dec(C);          %��������תʮ����

                for i = 1 : N
                    D(i) = bitxor(SS(i),k2(i));
                end
                                
                DS = dec2bin(D);
                E = DS;
                E(:,2) = DS(:,6);
                E(:,6) = DS(:,2);
                E(:,4) = DS(:,8);
                E(:,8) = DS(:,4);
                SS_NEW = bin2dec(E);          %��������תʮ����

                for i = 1 : N0
                    k3(2*i -1) = mod(round((obj.chaos_sequence(i,1) - floor(obj.chaos_sequence(i,1)))*1e14),256);
                    k3(2*i) = mod(round((obj.chaos_sequence(i,2) - floor(obj.chaos_sequence(i,2)))*1e14),256);
                    k4(2*i -1) = (obj.chaos_sequence(i,3) - floor(obj.chaos_sequence(i,3)))*1e5;
                    k4(2*i) = (obj.chaos_sequence(i,4) - floor(obj.chaos_sequence(i,4)))*1e5;
                end
             
                G0 = mod(sum(diag(obj.plaintext_img)),256)
                for i = 1:N
                    F(i) = bitxor(SS_NEW(i),round(k3(i)));
                    H(i) = bitxor(mod(floor(k1(i) + k4(i)),256),F(i));

                    if(i ==1)
                       G(i) = bitxor(H(i),G0);
                    else
                       G(i) = bitxor(H(i),G(i-1));
                    end
                end
                blur_img = reshape(G,obj.m,obj.n);
         end
        
        
          function [deblur_img]=decryption(obj,img)
                 N0 = obj.m * obj.n / 2;
                 N = obj.m * obj.n;
                for i = 1 : N0
                    k1(2*i -1) = (obj.chaos_sequence(i,1) - floor(obj.chaos_sequence(i,1)))*1e5;
                    k1(2*i) = (obj.chaos_sequence(i,2) - floor(obj.chaos_sequence(i,2)))*1e5;
                    k2(2*i -1) = mod(round((obj.chaos_sequence(i,3) - floor(obj.chaos_sequence(i,3)))*1e14),256);
                    k2(2*i) = mod(round((obj.chaos_sequence(i,4) - floor(obj.chaos_sequence(i,4)))*1e14),256);
                    k3(2*i -1) = mod(round((obj.chaos_sequence(i,1) - floor(obj.chaos_sequence(i,1)))*1e14),256);
                    k3(2*i) = mod(round((obj.chaos_sequence(i,2) - floor(obj.chaos_sequence(i,2)))*1e14),256);
                    k4(2*i -1) = (obj.chaos_sequence(i,3) - floor(obj.chaos_sequence(i,3)))*1e5;
                    k4(2*i) = (obj.chaos_sequence(i,4) - floor(obj.chaos_sequence(i,4)))*1e5;       
                end
        
              G = reshape(img,N,1);
              G0 = mod(sum(sum(obj.plaintext_img)),256);
               for i = 1 : N
                  
                    if(i ==1)
                       H(i) = bitxor(G(i),G0);
                    else
                       H(i) = bitxor(G(i),G(i-1));
                    end
                    F(i) = bitxor(mod(floor(k1(i) + k4(i)),256),H(i));
                    SS_NEW(i) = bitxor(F(i),round(k3(i)));
               end
              
               E = dec2bin(SS_NEW);
               
                DS = E ;
                DS(:,2)= E(:,6);
                DS(:,6)= E(:,2);
                DS(:,4)= E(:,8);
                DS(:,8)= E(:,4);
                D = bin2dec(DS);
                    
                for i = 1:N
                    SS(i) = bitxor(D(i),k2(i));
                end

                
                C = dec2bin(SS);
               
                BS = C ;
                BS(:,1)= C(:,5);
                BS(:,5)= C(:,1);
                BS(:,3)= C(:,7);
                BS(:,7)= C(:,3);
                B = bin2dec(BS);
               
                [k1_new,Ik1] = sort(k1); 
                 Ik1_s = zeros(N,1);
                 for i = 1: N
                    Ik1_s(Ik1(i)) = i;
                 end
               
                 for i = 1:N
                    S(i) = B(Ik1_s(i));
                 end
               
                deblur_img = reshape(S,obj.m,obj.n);
                
          end
              
        
        % ����ͼ������������������ص�
        function [records_pixel]=near_pixel(obj, img)
              k=1;
             for i =1 : obj.m-1
                 for j = 1 : obj.n-1
                     xk(k) = img(i,j);
                     xk_horizontal(k) = img(i+1,j);      %(i,j)λ�����ص��ˮƽ����
                     xk_verital(k) = img(i,j+1);      %(i,j)λ�����ص�Ĵ�ֱ����
                     xk_diag(k) = img(i+1,j+1);      %(i,j)λ�����ص�ĶԽ��߷���
                     k=k+1;
                 end
             end
             records_pixel = [xk;xk_horizontal;xk_verital;xk_diag]';
         end
        
        %����ͼ����Ϣ��
        function [H_x]=energy_shan(obj,img)
                 G=256;              %ͼ��ĻҶȼ�   
                 H_x = 0;
                 nk = zeros(G,1);
                 for i =1 : obj.m
                     for j = 1 : obj.n
                         img_level = img(i,j) +1 ; %��ȡͼ��ĻҶȼ��ĵ���
                         nk(img_level) = nk(img_level) +1;
                     end
                 end
               for k =1 : G
                   PS(k) = nk(k)/(obj.m * obj.n);         %����ÿ�����ص�ĸ���
                   if(PS(k)~= 0)
                       H_x = - PS(k)*log2(PS(k)) + H_x;   %���ع�ʽ
                   end
               end
        end

   end
end