%% cleaning house
clear all
close all
clc
%  defining axis
ax = axes('XLim',[0 100],'YLim',[0 100]); %sets max and min axes for x,y plane
view(3); %sets 3d graph viewing angle
grid off;
axis equal;
[Xg,Yg] = meshgrid(-10:0.1:10,-10:0.1:10);                                
Zg =.00001*Xg+.0001*Yg;                                        
surf(Xg,Yg,Zg,'edgecolor','none','facecolor','white') %creates 2d plane
colormap white
axis equal
set(gcf,'Color','black') %sets background to black
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[scrsz(1) scrsz(2)+scrsz(4)/20 scrsz(3) scrsz(4)*17/20]); %Displays fullscreen graph
%% moving object codes
[xt,yt,zt] = sphere(20);
%drawing spheres
j=0.5;
h=1;
A(1) = surface(h*xt,-h*yt,h*zt+h+j,'FaceColor','y','edgecolor','none'); %sun
B(1) = surface(j*xt,-j*yt,j*zt+j+h,'FaceColor','r','edgecolor','none'); %jupiter
% C(1) = surface(h*xt,-h*yt,h*zt+j+h,'FaceColor','b','edgecolor','none'); %Rcom
t1 = hgtransform('Parent',ax); %places trasform object 1 onto prepared axes ax
set(A,'Parent',t1) %sets object B as the parent of transform 1(t1)
set(gcf,'Renderer','opengl') %selects renderer package
t2 = hgtransform('Parent',ax);
set(B,'Parent',t2);
set(gcf,'Renderer','opengl');
% t3 = hgtransform('Parent',ax);
% set(C,'Parent',t3);
drawnow
%% setting initial conditions
%universal gravity constant
G=39.478;
%sun
m1=.98;
x1=0;
y1=0;
vx1=0;
vy1=0.00267;
%jupiter
m2=1/1047;
x2=-5.2;
y2=0;
vx2=0;
vy2=-2.754;
%finilizing conditions and setting timer
tspan=[1:0.001:26];
y=[x1,vx1,x2,vx2,y1,vy1,y2,vy2];
i=1;
zbea=0;
%% equations of motion
[t,x]=ode45(@(tspan,y) twobody(tspan,y,G,m1,m2), tspan, y);
xeven = x(10:10:end,:)
I=size(xeven,1);
%% graphics loop
v = VideoWriter('JupiterSun.avi');
open(v);
for i=1:I;
%movment

trans1=makehgtform('translate',[xeven(i,1) xeven(i,5) 0]);
rotz1=makehgtform('zrotate',zbea);

trans2=makehgtform('translate',[xeven(i,3) xeven(i,7) 0]);
rotz2=makehgtform('zrotate',zbea);

set(t1,'matrix',trans1*rotz1)
set(t2,'matrix',trans2*rotz2)
% set(t3,'matrix',trans3*rotz2);

pause(.0000005);
frame = getframe(gcf);
writeVideo(v,frame);
end

figure(2)
subplot(2,1,1)
plot(t,x(:,3),'r')
ylabel('x position of Jupiter (AU)')
xlabel('time')
subplot(2,1,2)
plot(t,x(:,7),'r')
ylabel('y position of Jupiter (AU)')
xlabel('time')
figure(3)
subplot(2,1,1)
plot(t,x(:,1),'g')
ylabel('x position of Sol (AU)')
xlabel('time')
subplot(2,1,2)
plot(t,x(:,5),'g')
ylabel('y position of Sol (AU)')
xlabel('time')
figure(4)
V1=sqrt((x(:,4).^2)+(x(:,8).^2));
plot(t,V1,'r')
ylabel('magnitude of object Jupiters velocty (AU/yr)')
xlabel('time')
figure(5)
plot(x(:,1), x(:,5),'g')
figure(6)
plot(x(:,3), x(:,7),'r')

