%% Testing for the residuals code:
clear all
close all
for i = 1:100
    a(i) = i;
    b(i) = i + rand*10;
end

coef = polyfit(a,b,1);
r = residuals([a' b'], coef);

plot(a,b,'o','Color','blue')
hold all
plot(1:100,[1:100]*coef(1)+coef(2),'LineWidth',2,'Color','red')
for i = 1:100
    plot([a(i) a(i)],[a(i)*coef(1)+coef(2) a(i)*coef(1)+coef(2)+r(i)],'color','red')
end

%%%%%%%%%%%%%%%
%% Testing for the chow test code:
clear all
close all

window = 70;
length = 1000;

a = 1;
b = 2;
c = 2;

for i = 2:1000
    a(i) = i;
    if i < round(1000/2)
        b(i) = b(i-1)+2;
        c(i) = b(i)+rand*100;
        %c(i) = c(i) + sin(i/10)*40;
    else
        b(i) = b(i-1) + 0.5;
        c(i) = b(i)+rand*100;
        %c(i) = c(i) + sin(i/10)*40;
    end
end

subplot(2,1,1)
plot(a,c,'o','Color','blue')

chow = rolling_chowtest([a' c'],window,window);

subplot(2,1,2)
plot(chow(:,1),chow(:,2),'o')
xlim([0 length])