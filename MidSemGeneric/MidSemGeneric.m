clear all;

%Student ID (Change this to your student number)
ID = 45678901;
fid = fopen(sprintf('%i.txt',ID),'wt');

%%%GENERIC SETUP%%%%

%Here is a grid of points
Nx = 256;
Ny = Nx;
%X and Y axis in units of metres
x = (((1:Nx)-(Nx./2))./Nx);
y = (((1:Nx)-(Nx./2))./Nx);
[X Y] = meshgrid(x,y);

%time axis in units of seconds
Nt = Nx;
timeAxis = linspace(0,10,Nt);
%END OF SETUP


%This function takes an input of your studentID and an x and y axis, and
%outputs a random circle (C)
[C] = circleGenerator(ID,X,Y);

%%%%%%%%%%%%%%%%%%%%  CIRCLE PROPERTIES  (2 marks) %%%%%%%%%%%%
%QUESTION 1 : What's the area, radius and centre position of your circle?

%%WORKING START
circleArea = 0;
circleRadius = 0;
circlePositionX = 0;
circlePositionY = 0;
%%WORKING END

%%PRINT ANSWER (Do not modify)
disp('Q1');
fprintf(fid,'Area (m^2)	%3.3f\n',circleArea);
fprintf(fid,'Radius (m)	%3.3f\n',circleRadius);
fprintf(fid,'Centre position X (m)	%3.3f\n',circlePositionX);
fprintf(fid,'Centre position Y (m)	%3.3f\n',circlePositionY);
%%PRINT ANSWER END

%This function takes an input of your studentID and outputs a displacement of a
%thing at a certain point in time.
s = travelGenerator(ID,timeAxis);

%%%%%%%%%% MOVING THING (2 marks) %%%%%%%%%%%%%%
%QUESTION 2 : Calculate the position, velocity and acceleration of your
%thing, at t = 1

%%WORKING START
velocity = 0;
acceleration = 0;
position = 0;
%%WORKING END

%%PRINT ANSWER (Do not modify)
disp('Q2');
fprintf(fid,'Position at t=1 (m)	%3.3f\n',position);
fprintf(fid,'Velocity at t=1	(m/s)	%3.3f\n',velocity);
fprintf(fid,'Acceleration at t=1 (m/s^2)	%3.3f\n',acceleration);
%%PRINT ANSWER END

%%%%%%% SIMPLE CALCULATIONS (2 marks) %%%%%%%%%%%

%QUESTION 3 : If I had $100 in my bank account and I spend $20 of that on 
%antique cans, how much money do I have remaining?

%%WORKING START
bankBalance = 0;
%%WORKING END

%%PRINT ANSWER (Do not modify)
disp('Q3');
fprintf(fid,'Bank balance ($)	%3.3f\n',bankBalance);
%%PRINT ANSWER END
fclose(fid);
