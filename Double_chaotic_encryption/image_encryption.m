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
         function blur_img = encryption(obj)
%                 N0 = obj.m * obj.n / 2;
                N = obj.m * obj.n;
                xk1 = obj.chaos_sequence(:,1);
                yk1 = obj.chaos_sequence(:,2);
                xk2 = obj.chaos_sequence(:,3);
                yk2 = obj.chaos_sequence(:,4);
                zk2 = obj.chaos_sequence(:,5);
                              
                for i = 1 : N
                   xm = xk1 + xk2;
                   ym = yk1 + yk2 ;
                end

                [k1_new,Ix] = sort(xm,1);        %����xm�������е���������
                [k2_new,Iy] = sort(ym,1,'descend');        %����ym�������е���������
                S = reshape(obj.plaintext_img,N,1);

                for i = 1 : N
                    T(i) = S(Ix(i));
                end
              
                for i = 1 : N
                   S_sp(i) = T(Iy(i));
                end
                
                C = reshape(S_sp,obj.m,obj.n);
              
               for i = 1 : N
                   R1(i) = mod(floor(abs(xk2(i) - floor(xk2(i)))*10e8),256);
                   R2(i) = mod(floor(abs(yk2(i) - floor(yk2(i)))*10e8),256);
                   R3(i) = mod(floor(abs(zk2(i)- floor(zk2(i)))*10e8),256); 
                end
                
                k1 = uint8(reshape(R1,obj.m,obj.n));
                k2 =  uint8(reshape(R2,obj.m,obj.n));
                k3 =  uint8(reshape(R3,obj.m,obj.n));

%                 for i = 1 : N
%                     D(i) = bitxor(SS(i),k2(i));
%                 end
                                
                for i = 1 : obj.m / 2 
                    g1(2*i -1) = mod(floor(abs(xk2(i) - floor(xk2(i)))*10e8),256);
                    g1(2*i) = mod(floor(abs(yk2(i) - floor(yk2(i)))*10e8),256);
                end
                                         
                for j = 1 : obj.n / 2 
                    g2(2*j -1) = mod(floor(abs(yk2(i) - floor(yk2(i)))*10e8),256);
                    g2(2*j) = mod(floor(abs(zk2(i) - floor(zk2(i)))*10e8),256);
                end     
                g1 = uint8(g1);
                g2 = uint8(g2);
               
                h1 = reshape(xk1,obj.m,obj.n);
                h2 = reshape(yk1,obj.m,obj.n);
                %����ɢ
                for i = 1 : obj.m
                    for j =1 : obj.n
                        D1(i,j) = mod(k1(i,j) + round(h1(i,j)*10e5), 256);
                        E1(i,j) = bitxor(bitxor(k1(i,j),C(i,j)),D1(i,j));
                        if(i == 1)
                           F1(i,j) =bitxor(E1(i,j), g2(j));
                        else
                           F1(i,j) = bitxor(E1(i,j),F1(i-1,j));
                        end
                   end
                end
                %����ɢ
                for i = 1 : obj.m
                    for j =1 : obj.n
                        D2(i,j) = mod(k2(i,j) + round(h2(i,j)*10e5), 256);
                        E2(i,j) = bitxor(bitxor(k2(i,j),F1(i,j)),D2(i,j));
                        if(j ==1)
                           F2(i,j) = bitxor(E2(i,j),g1(i));
                        else
                           F2(i,j) = bitxor(E2(i,j),F2(i,j-1));
                        end
                   end
                end
                
                M = bitxor(k3,F2);
                blur_img = M;
          end
        
          function deblur_img = decryption(obj,blur_img)
                 
                 N0 = obj.m * obj.n / 2;
                 N = obj.m * obj.n;
                 xk1 = obj.chaos_sequence(:,1);
                 yk1 = obj.chaos_sequence(:,2);
                 xk2 = obj.chaos_sequence(:,3);
                 yk2 = obj.chaos_sequence(:,4);
                 zk2 = obj.chaos_sequence(:,5);
                              
                for i = 1 : N
                   xm = xk1 + xk2;
                   ym = yk1 + yk2 ;
                end
                for i = 1 : N
                   R1(i) = mod(floor(abs(xk2(i) - floor(xk2(i)))*10e8),256);
                   R2(i) = mod(floor(abs(yk2(i) - floor(yk2(i)))*10e8),256);
                   R3(i) = mod(floor(abs(zk2(i)- floor(zk2(i)))*10e8),256); 
                end
                
                k1 = uint8(reshape(R1,obj.m,obj.n));
                k2 =  uint8(reshape(R2,obj.m,obj.n));
                k3 =  uint8(reshape(R3,obj.m,obj.n));
                 
                for i = 1 : obj.m / 2
                    g1(2*i -1) = mod(floor(abs(xk2(i) - floor(xk2(i)))*10e8),256);
                    g1(2*i) = mod(floor(abs(yk2(i) - floor(yk2(i)))*10e8),256);
                end
                                         
                for j = 1 : obj.n / 2
                    g2(2*j -1) = mod(floor(abs(yk2(i) - floor(yk2(i)))*10e8),256);
                    g2(2*j) = mod(floor(abs(zk2(i) - floor(zk2(i)))*10e8),256);
                end       
                g1 = uint8(g1);
                g2 = uint8(g2);
                
                h1 = reshape(xk1,obj.m,obj.n);
                h2 = reshape(yk1,obj.m,obj.n); 
                      
                M = blur_img;
                F2 = bitxor(k3,M);
                
                %������ɢ
                for i = 1: obj.m 
                    for j = 1: obj.n
                        if(j ==1)
                           E2(i,j) = bitxor(F2(i,j),g1(i));
                        else
                           E2(i,j) = bitxor(F2(i,j),F2(i,j-1));
                        end
                        D2(i,j) = mod(k2(i,j) + round(h2(i,j)*10e5), 256);
                        F1(i,j) = bitxor(bitxor(k2(i,j),E2(i,j)),D2(i,j));
                   end
                end
                
                %������ɢ
                 for i = 1: obj.m 
                     for j = 1: obj.n
                        if(i == 1)
                           E1(i,j) = bitxor(F1(i,j),g2(j));
                        else
                           E1(i,j) = bitxor(F1(i,j),F1(i-1,j)); 
                        end                        
                        D1(i,j) = mod(k1(i,j) + round(h1(i,j)*10e5), 256);
                        C(i,j) = bitxor(bitxor(E1(i,j),k1(i,j)),D1(i,j));
                   end
                end   
                 
               
                [k1_new,Ix] = sort(xm,1);        %����xm�������е���������
                [k2_new,Iy] = sort(ym,1,'descend');        %����ym�������е���������
                
                 Ix_s = zeros(N,1);
                 Iy_s = zeros(N,1);
                 for i = 1: N
                    Ix_s(Ix(i)) = i;
                    Iy_s(Iy(i)) = i;
                 end
                
                 S_sp = reshape(C,N,1);
                 for i = 1 : N
                   T(i) = S_sp(Iy_s(i));
                 end
                 for i = 1 : N
                    S(i) = T(Ix_s(i));
                 end
                deblur_img = reshape(S,obj.m,obj.n);
                
          end
              
        
        % ����ͼ������������������ص�
        function [records_pixel] = near_pixel(obj, img)
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
        function [H_x] = energy_shan(obj,img)
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