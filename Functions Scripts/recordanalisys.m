function [Sp,S1,S2,S3,Hp,H1,H2,H3] = recordanalisys (firstopts, secondopts, thirdopts, Time, lpscnt, istime, handles)

S1 = 0;
S2 = 0;
S3 = 0;

H1 = 0;
H2 = 0;
H3 = 0;

recorder = audiorecorder;
overlap = 1;

if (nargin<1 || isempty(Time)),
    Time=1; 
end
if (nargin<2 || isempty(firstopts)),
    arr{1} = 1;
    arr{2} = 0;
    firstopts=arr;
end
if (nargin<3 || isempty(secondopts)),
    arr{1} = 1;
    arr{2} = 0;
    secondopts=arr;
end
if (nargin<4 || isempty(thirdopts)),
    arr{1} = 1;
    arr{2} = 0;
    thirdopts=arr; 
end
if (nargin<5 || isempty(istime)),
    istime=1; 
end
if (nargin<6 || isempty(handles)),
    handles=0; 
end

    
Fs = 8000;
Spf = Fs * Time;

list = cell(1,4);
list{1,1} = 'Mikrofon';
list{1,2} = '';
list{1,3} = Fs;
list{1,4} = Spf;

if istime == 1 
    frmt = Fs;
else
    frmt = 1;
end

index=1;
y2 = zeros(Spf,1);
y3 = zeros(Spf,1);
y4 = zeros(Spf,1);
y5 = zeros(Spf,1);
Sp = vertcat(y2,y3,y4,y5);


firstalg = firstopts{1};
secondalg = secondopts{1};
thirdalg = thirdopts{1};

if firstalg ~= 1
    switch firstalg
        case 2
            fsty2 = zeros(Spf,1);
            fsty3 = zeros(Spf,1);
            fsty4 = zeros(Spf,1);
            fsty5 = zeros(Spf,1);
            S1 = vertcat(fsty2,fsty3,fsty4,fsty5);
        case 3
            recordblocking(recorder, Time);
            sig = getaudiodata(recorder);
            y4 = sig(:,1);
            tym = mfcc(y4,firstopts{3},firstopts{4},firstopts{5},firstopts{6},Fs,firstopts{7});
            lgh = size(tym);
            lgh = lgh(2);
            fsty2 = zeros(firstopts{3},lgh);
            fsty3 = zeros(firstopts{3},lgh);
            fsty4 = zeros(firstopts{3},lgh);
            fsty5 = zeros(firstopts{3},lgh);
            S1 = horzcat(fsty2,fsty3,fsty4,fsty5);
            disp(size(S1));
        case 4
            recordblocking(recorder, Time);
            sig = getaudiodata(recorder);
            y4 = sig(:,1);
            tym = hfcc(y4,firstopts{3},firstopts{4},firstopts{5},firstopts{6},Fs,firstopts{7});
            disp(size(tym));
            lgh = size(tym);
            lgh = lgh(2);
            fsty2 = zeros(firstopts{3},lgh);
            fsty3 = zeros(firstopts{3},lgh);
            fsty4 = zeros(firstopts{3},lgh);
            fsty5 = zeros(firstopts{3},lgh);
            S1 = horzcat(fsty2,fsty3,fsty4,fsty5);
            disp(size(S1));
        case 5
            fsty2 = zeros(Spf,1);
            fsty3 = zeros(Spf,1);
            fsty4 = zeros(Spf,1);
            fsty5 = zeros(Spf,1);
            S1 = vertcat(fsty2,fsty3,fsty4,fsty5);

            switch firstopts{3} 
                case 1
                    [fstb,fsta] = butter(firstopts{4}, firstopts{5} ,'low');
                case 2
                    [fstb,fsta] = butter(firstopts{4}, firstopts{5} ,'high');
                case 3
                    [fstb,fsta] = butter(firstopts{4},[firstopts{5} firstopts{6}],'bandpass');
                otherwise
            end
        case 6
            fsty2 = zeros(1,firstopts{3});
            fsty3 = zeros(1,firstopts{3});
            fsty4 = zeros(1,firstopts{3});
            fsty5 = zeros(1,firstopts{3});
            S1 = horzcat(fsty2,fsty3,fsty4,fsty5);

        case 7
            fsty2 = zeros(firstopts{3},1);
            fsty3 = zeros(firstopts{3},1);
            fsty4 = zeros(firstopts{3},1);
            fsty5 = zeros(firstopts{3},1);
            S1 = horzcat(fsty2,fsty2,fsty3,fsty4,fsty5);
            tym = [(-3*Spf)/frmt (-2*Spf)/frmt (-1*Spf)/frmt 0 (Spf)/frmt];

        otherwise
    end

     if firstopts{2} == 1
         fsttxt = fileinit(list, firstopts, 0, Time, 0);
     end

    fpy1 = 0;
    fpy2 = 1000;

end

if secondalg ~= 1

    switch secondalg
        case 2
            sndy2 = zeros(Spf,1);
            sndy3 = zeros(Spf,1);
            sndy4 = zeros(Spf,1);
            sndy5 = zeros(Spf,1);
            S2 = vertcat(sndy2,sndy3,sndy4,sndy5);
       case 3
            recordblocking(recorder, Time);
            sig = getaudiodata(recorder);
            y4 = sig(:,1);
            tym = mfcc(y4,secondopts{3},secondopts{4},secondopts{5},secondopts{6},Fs,secondopts{7});
            lgh = size(tym);
            lgh = lgh(2);
            sndy2 = zeros(secondopts{3},lgh);
            sndy3 = zeros(secondopts{3},lgh);
            sndy4 = zeros(secondopts{3},lgh);
            sndy5 = zeros(secondopts{3},lgh);
            S2 = horzcat(sndy2,sndy3,sndy4,sndy5);
        case 4
            recordblocking(recorder, Time);
            sig = getaudiodata(recorder);
            y4 = sig(:,1);
            tym = hfcc(y4,secondopts{3},secondopts{4},secondopts{5},secondopts{6},Fs,secondopts{7});
            lgh = size(tym);
            lgh = lgh(2);
            sndy2 = zeros(secondopts{3},lgh);
            sndy3 = zeros(secondopts{3},lgh);
            sndy4 = zeros(secondopts{3},lgh);
            sndy5 = zeros(secondopts{3},lgh);
            S2 = horzcat(sndy2,sndy3,sndy4,sndy5);
        case 5
            sndy2 = zeros(Spf,1);
            sndy3 = zeros(Spf,1);
            sndy4 = zeros(Spf,1);
            sndy5 = zeros(Spf,1);
            S2 = vertcat(sndy2,sndy3,sndy4,sndy5);

            switch secondopts{3} 
                case 1
                    [sndb,snda] = butter(secondopts{4}, secondopts{5} ,'low');
                case 2
                    [sndb,snda] = butter(secondopts{4}, secondopts{5} ,'high');
                case 3
                    [sndb,snda] = butter(secondopts{4},[secondopts{5} secondopts{6}],'bandpass');
                otherwise
            end

        case 6
            sndy2 = zeros(1,secondopts{3});
            sndy3 = zeros(1,secondopts{3});
            sndy4 = zeros(1,secondopts{3});
            sndy5 = zeros(1,secondopts{3});
            S2 = horzcat(sndy2,sndy3,sndy4,sndy5);
        case 7
            sndy2 = zeros(secondopts{3},1);
            sndy3 = zeros(secondopts{3},1);
            sndy4 = zeros(secondopts{3},1);
            sndy5 = zeros(secondopts{3},1);
            S2 = horzcat(sndy2,sndy2,sndy3,sndy4,sndy5);
            tym = [(-3*Spf)/frmt (-2*Spf)/frmt (-1*Spf)/frmt 0 (Spf)/frmt];
        otherwise
    end

    if secondopts{2} == 1
        sndtxt = fileinit(list, secondopts, 0, Time, 0);
    end
    spy1 = 0;
    spy2 = 1000;
end

if thirdalg ~= 1

    switch thirdalg
        case 2
            trdy2 = zeros(Spf,1);
            trdy3 = zeros(Spf,1);
            trdy4 = zeros(Spf,1);
            trdy5 = zeros(Spf,1);
            S3 = vertcat(trdy2,trdy3,trdy4,trdy5);
        case 3
            recordblocking(recorder, Time);
            sig = getaudiodata(recorder);
            y4 = sig(:,1);
            tym = mfcc(y4,secondopts{3},secondopts{4},secondopts{5},secondopts{6},Fs,secondopts{7});
            lgh = size(tym);
            lgh = lgh(2);
            trdy2 = zeros(thirdopts{3},lgh);
            trdy3 = zeros(thirdopts{3},lgh);
            trdy4 = zeros(thirdopts{3},lgh);
            trdy5 = zeros(thirdopts{3},lgh);
            S3 = horzcat(trdy2,trdy3,trdy4,trdy5);
        case 4
            recordblocking(recorder, Time);
            sig = getaudiodata(recorder);
            y4 = sig(:,1);
            tym = hfcc(y4,secondopts{3},secondopts{4},secondopts{5},secondopts{6},Fs,secondopts{7});
            lgh = size(tym);
            lgh = lgh(2);
            trdy2 = zeros(thirdopts{3},lgh);
            trdy3 = zeros(thirdopts{3},lgh);
            trdy4 = zeros(thirdopts{3},lgh);
            trdy5 = zeros(thirdopts{3},lgh);
            S3 = horzcat(trdy2,trdy3,trdy4,trdy5);
        case 5
            trdy2 = zeros(Spf,1);
            trdy3 = zeros(Spf,1);
            trdy4 = zeros(Spf,1);
            trdy5 = zeros(Spf,1);
            S3 = vertcat(trdy2,trdy3,trdy4,trdy5);

            switch thirdopts{3} 
                case 1
                    [trdb,trda] = butter(thirdopts{4}, thirdopts{5} ,'low');
                case 2
                    [trdb,trda] = butter(thirdopts{4}, thirdopts{5} ,'high');
                case 3
                    [trdb,trda] = butter(thirdopts{4},[thirdopts{5} thirdopts{6}],'bandpass');
                otherwise
            end

        case 6
            trdy2 = zeros(1,thirdopts{3});
            trdy3 = zeros(1,thirdopts{3});
            trdy4 = zeros(1,thirdopts{3});
            trdy5 = zeros(1,thirdopts{3});
            S3 = horzcat(trdy2,trdy3,trdy4,trdy5);
        case 7
            trdy2 = zeros(thirdopts{3},1);
            trdy3 = zeros(thirdopts{3},1);
            trdy4 = zeros(thirdopts{3},1);
            trdy5 = zeros(thirdopts{3},1);
            S3 = horzcat(trdy2,trdy2,trdy3,trdy4,trdy5);
            tym = [(-3*Spf)/frmt (-2*Spf)/frmt (-1*Spf)/frmt 0 (Spf)/frmt];
        otherwise
    end

    if thirdopts{2} == 1
        trdtxt = fileinit(list, thirdopts, 0, Time, 0);
    end
    tpy1 = 0;
    tpy2 = 1000;
end

it = 1;

while it <= lpscnt
            Lin = linspace((index-(3*Spf)+(it*(Spf*(overlap))))/frmt,(index-(3*Spf)+(it*(Spf*(overlap)))+(4*Spf))/frmt,4*Spf);
            y1 = y2;
            y2 = y3;
            y3 = y4;
            recordblocking(recorder, Time);
            sig = getaudiodata(recorder);
            y4 = sig(:,1);
            S = vertcat(y1,y2,y3,y4);
            Sp = vertcat(Sp,y4);
            Hp = subplot(5,1,2);
            plot(Lin,S);
            axis([(index-(3*Spf)+(it*(Spf*overlap)))/frmt (index-(3*Spf)+(it*(Spf*overlap))+length(S))/frmt -1 1]);
            vline((Spf+index-(3*Spf)+(it*(Spf*overlap)))/frmt);
            vline(((2*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
            vline(((3*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
            vline(((4*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);

            if firstalg ~= 1
                fsty1 = fsty2;
                fsty2 = fsty3;
                fsty3 = fsty4;
                H1 = subplot(5,1,3);

                switch firstalg
                    case 1
                    case 2                        
                        fsty4 = abs(fft(y4));
                        S = vertcat(fsty1,fsty2,fsty3,fsty4);
                        S1 = vertcat(S1,fsty4);
                        roof = max(S1);
                        plot(Lin,S);
                        axis([(index-(3*Spf)+(it*(Spf*overlap)))/frmt (index-(3*Spf)+(it*(Spf*overlap))+length(S))/frmt 0 roof]);
                        vline((Spf+index-(3*Spf)+(it*(Spf*overlap)))/frmt);
                        vline(((2*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        vline(((3*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                    case 3
                        fsty4 = mfcc(y4,firstopts{3},firstopts{4},firstopts{5},firstopts{6},Fs,firstopts{7});
                        S = horzcat(fsty1,fsty2,fsty3,fsty4);
                        S1 = horzcat(S1,fsty4);
                        lgh = size(S);
                        surface(S);
                        set(H1,'xlim',[1 lgh(2)]);
                        set(H1,'ylim',[1 lgh(1)]);
                    case 4
                        fsty4 = hfcc(y4,firstopts{3},firstopts{4},firstopts{5},firstopts{6},Fs,firstopts{7});
                        S = horzcat(fsty1,fsty2,fsty3,fsty4);
                        S1 = horzcat(S1,fsty4);
                        lgh = size(S);
                        surface(S);
                        set(H1,'xlim',[1 lgh(2)]);
                        set(H1,'ylim',[1 lgh(1)]);
                    case 5
                        fsty4 = filter(fstb,fsta,y4.^2);
                        S = vertcat(fsty1,fsty2,fsty3,fsty4);
                        plot(Lin,S);
                        S1 = vertcat(S1,fsty4);
                        roof = max(S1);
                        axis([(index-(3*Spf)+(it*(Spf*overlap)))/frmt (index-(3*Spf)+(it*(Spf*overlap))+length(S))/frmt -roof roof]);
                        vline((Spf+index-(3*Spf)+(it*(Spf*overlap)))/frmt);
                        vline(((2*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        vline(((3*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        %vline(((4*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                    case 6
                        Lin = linspace((firstopts{3}*it)-(firstopts{3}*5)+1,firstopts{3}*it,4*firstopts{3});
                        fsty4 = lpc(y4,firstopts{3});
                        fsty4 = fsty4(2:end);
                        S = horzcat(fsty1,fsty2,fsty3,fsty4);
                        plot(Lin,S);
                        S1 = horzcat(S1,fsty4);
                        axis([(firstopts{3}*it)-(firstopts{3}*5)+1 firstopts{3}*(it-1) -5 5 ]);
                        vline(firstopts{3});
                        vline((2*(firstopts{3})));
                        vline((3*(firstopts{3})));
                        vline((4*(firstopts{3})));
                    case 7
                        fsty4 = fsty5;
                        if firstopts{4} == 1
                            fsty5 = formantx(y4,Fs,firstopts{3});
                        else
                            fsty5 = formant2(y4,Fs,8,firstopts{3});
                        end
                        fsty5 = fsty5';
                        S = horzcat(fsty1,fsty2,fsty3,fsty4,fsty5);
                        S1 = horzcat(S1,fsty5);
                        roof = max(max(S1));
                        tym = circshift(tym,[0 -1]);
                        tym(1,5) = ((index+Spf)-1)/frmt;
                        plot(tym,S(1,:),'r');
                        hold on;
                        disp(length(roof));
                        disp(length([(index-(3*Spf)+(it*(Spf*overlap)))/frmt (index-(3*Spf)+(it*(Spf*overlap))+(4*Spf))/frmt 0 4000 ]));
                        %disp([(index-(3*Spf)+(it*(Spf*overlap)))/frmt (index-(3*Spf)+(it*(Spf*overlap))+(4*Spf))/frmt 0 roof ]);
                        axis([(index-(3*Spf)+(it*(Spf*overlap)))/frmt (index-(3*Spf)+(it*(Spf*overlap))+(4*Spf))/frmt 0 roof ]);
                        plot(tym,S(2,:),'b');
                        plot(tym,S(3,:),'g');
                        hold off;

                        vline((Spf+index-(3*Spf)+(it*(Spf*overlap)))/frmt);
                        vline(((2*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        vline(((3*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        vline(((4*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                    otherwise
                end

                if firstopts{2} == 1
                    fprintf(fsttxt,'[%d\t%d]',(index/frmt),((index+Spf-1)/frmt));
                    switch firstalg
                        case 2
                            fprintf(fsttxt,'\t%f',fsty4(:,1));
                            fprintf(fsttxt,'\n');
                        case 3
                            lgh = size(fsty4);
                            for i = 1:lgh(1)
                                fprintf(fsttxt,'\t%f',fsty4(i,:));
                                fprintf(fsttxt,'\n');
                                fprintf('            ');
                            end
                        case 4
                            lgh = size(fsty4);
                            for i = 1:lgh(1)
                                fprintf(fsttxt,'\t%f',fsty4(i,:));
                                fprintf(fsttxt,'\n');
                                fprintf('            ');
                            end
                        case 5
                            fprintf(fsttxt,'\t%f',fsty4(:,1));
                            fprintf(fsttxt,'\n');
                        case 6
                            fprintf(fsttxt,'\t%f',fsty4(2:end));
                            fprintf(fsttxt,'\n');
                        case 7
                            fprintf(fsttxt,'\t%f',fsty5(:,1));
                            fprintf(fsttxt,'\n');
                        otherwise
                    end
                end
            end

           if secondalg ~= 1
                sndy1 = sndy2;
                sndy2 = sndy3;
                sndy3 = sndy4;
                H2 = subplot(5,1,4);

                switch secondalg
                    case 1
                    case 2
                        sndy4 = abs(fft(y4));
                        S = vertcat(sndy1,sndy2,sndy3,sndy4);
                        S2 = vertcat(S2,sndy4);
                        roof = max(S2);
                        plot(Lin,S);
                        axis([(index-(3*Spf)+(it*(Spf*overlap)))/frmt (index-(3*Spf)+(it*(Spf*overlap))+length(S))/frmt 0 roof]);
                        vline((Spf+index-(3*Spf)+(it*(Spf*overlap)))/frmt);
                        vline(((2*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        vline(((3*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                    case 3
                        sndy4 = mfcc(y4,secondopts{3},secondopts{4},secondopts{5},secondopts{6},Fs,secondopts{7});
                        S = horzcat(sndy1,sndy2,sndy3,sndy4);
                        S2 = horzcat(S2,sndy4);
                        lgh = size(S);
                        surface(S);
                        set(H2,'xlim',[1 lgh(2)]);
                        set(H2,'ylim',[1 lgh(1)]);
                    case 4
                        sndy4 = hfcc(y4,secondopts{3},secondopts{4},secondopts{5},secondopts{6},Fs,secondopts{7});
                        S = horzcat(sndy1,sndy2,sndy3,sndy4);
                        S2 = horzcat(S2,sndy4);
                        lgh = size(S);
                        surface(S);
                        set(H2,'xlim',[1 lgh(2)]);
                        set(H2,'ylim',[1 lgh(1)]);
                    case 5
                        sndy4 = filter(sndb,snda,y4.^2);
                        S = vertcat(sndy1,sndy2,sndy3,sndy4);
                        S2 = vertcat(S2,sndy4);
                        roof = max(S2);
                        plot(Lin,S);
                        axis([(index-(3*Spf)+(it*(Spf*overlap)))/frmt (index-(3*Spf)+(it*(Spf*overlap))+length(S))/frmt -roof roof]);
                        vline((Spf+index-(3*Spf)+(it*(Spf*overlap)))/frmt);
                        vline(((2*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        vline(((3*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                    case 6
                        Lin = linspace((secondopts{3}*it)-(secondopts{3}*5)+1,secondopts{3}*it,4*secondopts{3});
                        sndy4 = lpc(y4,secondopts{3});
                        sndy4 = sndy4(2:end);
                        S = horzcat(sndy1,sndy2,sndy3,sndy4);
                        S2 = horzcat(S2,sndy4);
                        plot(Lin,S);
                        axis([(secondopts{3}*it)-(secondopts{3}*5)+1 secondopts{3}*(it-1) -5 5 ]);
                        vline(secondopts{3});
                        vline((2*(secondopts{3})));
                        vline((3*(secondopts{3})));
                        vline((4*(secondopts{3})));
                    case 7
                        sndy4 = sndy5;
                        if firstopts{4} == 1
                            sndy5 = formantx(y4,Fs,secondopts{3});
                        else
                            sndy5 = formant2(y4,Fs,8,secondopts{3});
                        end
                        sndy5 = sndy5';
                        S = horzcat(sndy1,sndy2,sndy3,sndy4,sndy5);
                        S2 = horzcat(S2,sndy5);
                        roof = max(max(S2));
                        tym = circshift(tym,[0 -1]);
                        tym(1,5) = ((index+Spf)-1)/frmt;
                        plot(tym,S(1,:),'r');
                        hold on;
                        axis([(index-(3*Spf)+(it*(Spf*overlap)))/frmt (index-(3*Spf)+(it*(Spf*overlap))+(4*Spf))/frmt 0 roof ]);
                        plot(tym,S(2,:),'b');
                        plot(tym,S(3,:),'g');
                        hold off;

                        vline((Spf+index-(3*Spf)+(it*(Spf*overlap)))/frmt);
                        vline(((2*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        vline(((3*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        vline(((4*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                    otherwise
                end

                if secondopts{2} == 1
                    fprintf(sndtxt,'[%d\t%d]',(index/frmt),((index+Spf-1)/frmt));
                    switch secondalg
                        case 2
                            fprintf(sndtxt,'\t%f',sndy4(:,1));
                            fprintf(sndtxt,'\n');
                        case 3
                            lgh = size(sndy4);
                            for i = 1:lgh(1)
                                fprintf(sndtxt,'\t%f',sndy4(i,:));
                                fprintf(sndtxt,'\n');
                                fprintf('            ');
                            end
                        case 4
                            lgh = size(sndy4);
                            for i = 1:lgh(1)
                                fprintf(sndtxt,'\t%f',sndy4(i,:));
                                fprintf(sndtxt,'\n');
                                fprintf('            ');
                            end
                        case 5
                            fprintf(sndtxt,'\t%f',sndy4(:,1));
                            fprintf(sndtxt,'\n');
                        case 6
                            fprintf(sndtxt,'\t%f',sndy4(2:end));
                            fprintf(sndtxt,'\n');
                        case 7
                            fprintf(sndtxt,'\t%f',sndy5(:,1));
                            fprintf(sndtxt,'\n');
                        otherwise
                    end
                end
            end

            if thirdalg ~= 1
                trdy1 = trdy2;
                trdy2 = trdy3;
                trdy3 = trdy4;
                H3 = subplot(5,1,5);

                switch thirdalg
                    case 1
                    case 2
                        trdy4 = abs(fft(y4));
                        S = vertcat(trdy1,trdy2,trdy3,trdy4);
                        S3 = vertcat(S3,trdy4);
                        roof = max(S3);
                        plot(Lin,S);
                        axis([(index-(3*Spf)+(it*(Spf*overlap)))/frmt (index-(3*Spf)+(it*(Spf*overlap))+length(S))/frmt 0 roof]);
                        vline((Spf+index-(3*Spf)+(it*(Spf*overlap)))/frmt);
                        vline(((2*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        vline(((3*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                    case 3
%                                 fsty4 = mfcc(y4,firstopts{2},firstopts{3},firstopts{4},firstopts{5},firstopts{6},firstopts{7});
%                                 trdy4 = mfcc(y4,thirdopts{3},thirdopts{4});
%                                 S = horzcat(trdy1,trdy2,trdy3,trdy4);
%                                 S3 = horzcat(S3,trdy4);
%                                 imagesc(S);
                        trdy4 = mfcc(y4,thirdopts{3},thirdopts{4},thirdopts{5},thirdopts{6},Fs,thirdopts{7});
                        S = horzcat(trdy1,trdy2,trdy3,trdy4);
                        S3 = horzcat(S3,trdy4);
                        lgh = size(S);
                        surface(S);
                        set(H3,'xlim',[1 lgh(2)]);
                        set(H3,'ylim',[1 lgh(1)]);
                    case 4
                        trdy4 = hfcc(y4,thirdopts{3},thirdopts{4},thirdopts{5},thirdopts{6},Fs,thirdopts{7});
                        S = horzcat(trdy1,trdy2,trdy3,trdy4);
                        S3 = horzcat(S3,trdy4);
                        lgh = size(S);
                        surface(S);
                        set(H3,'xlim',[1 lgh(2)]);
                        set(H3,'ylim',[1 lgh(1)]);
                    case 5
                        trdy4 = filter(trdb,trda,y4.^2);
                        S = vertcat(trdy1,trdy2,trdy3,trdy4);
                        S3 = vertcat(S3,trdy4);
                        roof = max(S3);
                        plot(Lin,S);
                        axis([(index-(3*Spf)+(it*(Spf*overlap)))/frmt (index-(3*Spf)+(it*(Spf*overlap))+length(S))/frmt -roof roof]);
                        vline((Spf+index-(3*Spf)+(it*(Spf*overlap)))/frmt);
                        vline(((2*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        vline(((3*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        %vline(((4*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                    case 6
                        Lin = linspace((thirdopts{3}*it)-(thirdopts{3}*5)+1,thirdopts{3}*it,4*thirdopts{3});
                        trdy4 = lpc(y4,thirdopts{3});
                        trdy4 = trdy4(2:end);
                        S = horzcat(trdy1,trdy2,trdy3,trdy4);
                        plot(Lin,S);
                        S3 = horzcat(S3,trdy4);
                        axis([(thirdopts{3}*it)-(thirdopts{3}*5)+1 thirdopts{3}*(it-1) -5 5 ]);
                        vline(thirdopts{3});
                        vline((2*(thirdopts{3})));
                        vline((3*(thirdopts{3})));
                        vline((4*(thirdopts{3})));
                    case 7
                        trdy4 = trdy5;
                        if thirdopts{4} == 1
                            trdy5 = formantx(y4,Fs,thirdopts{3});
                        else
                            trdy5 = formant2(y4,Fs,8,thirdopts{3});
                        end
                        trdy5 = trdy5';
                        S = horzcat(trdy1,trdy2,trdy3,trdy4,trdy5);
                        S3 = horzcat(S3,trdy5);
                        roof = max(max(S3));
                        tym = circshift(tym,[0 -1]);
                        tym(1,5) = ((index+Spf)-1)/frmt;
                        plot(tym,S(1,:),'r');
                        hold on;
                        axis([(index-(3*Spf)+(it*(Spf*overlap)))/frmt (index-(3*Spf)+(it*(Spf*overlap))+(4*Spf))/frmt 0 roof ]);
                        plot(tym,S(2,:),'b');
                        plot(tym,S(3,:),'g');
                        hold off;

                        vline((Spf+index-(3*Spf)+(it*(Spf*overlap)))/frmt);
                        vline(((2*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        vline(((3*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                        vline(((4*Spf+index-(3*Spf)+(it*(Spf*overlap))))/frmt);
                    otherwise
                end

                if thirdopts{2} == 1
                    fprintf(trdtxt,'[%d\t%d]',(index/frmt),((index+Spf-1)/frmt));
                    switch thirdalg
                        case 2
                            fprintf(trdtxt,'\t%f',trdy4(:,1));
                            fprintf(trdtxt,'\n');
                        case 3
                            lgh = size(trdy4);
                            for i = 1:lgh(1)
                                fprintf(trdtxt,'\t%f',trdy4(i,:));
                                fprintf(trdtxt,'\n');
                                fprintf('            ');
                            end
                        case 4
                            lgh = size(trdy4);
                            for i = 1:lgh(1)
                                fprintf(trdtxt,'\t%f',trdy4(i,:));
                                fprintf(trdtxt,'\n');
                                fprintf('            ');
                            end
                        case 5
                            fprintf(trdtxt,'\t%f',trdy4(:,1));
                            fprintf(trdtxt,'\n');
                        case 6
                            fprintf(trdtxt,'\t%f',trdy4(2:end));
                            fprintf(trdtxt,'\n');
                        case 7
                            fprintf(trdtxt,'\t%f',trdy5(:,1));
                            fprintf(trdtxt,'\n');
                        otherwise
                    end
                end
            end

            drawnow();
            index = index + (Spf*(1-overlap));

            set(handles.counteredit,'String',num2str(it));
            set(handles.countertext,'String',['\ ' num2str(it)]);
            set(handles.progress_slider,'Value',it);
            set(handles.progress_slider,'Max',it);
            set(handles.progress_slider, 'SliderStep', [1/it ,  1/it]);
            it = it + 1;
end

if firstopts{2} == 1
    switch firstopts{1}
        case 2
            fclose(fsttxt);
        case 3
        case 4
        case 5
            fclose(fsttxt);
        case 6
            name = System.IO.DirectoryInfo(fopen(fsttxt)).FullName;
            clnm = char(name);
            fclose(fsttxt);
            fopen(clnm,'r+');
            fprintf(fsttxt,'form_liczb\t typ_analizy\t l_formantów\t nazwa_mat\t cz_pr\t l_prob\n');
            fprintf(fsttxt,'%s\t %d\t %d\t %d\t %s\t %d\t %s\t %d\n\n','Float',Fs,samples,Spf,'LPC',firstopts{2},get(handles.filetext,'String'),it-1);
            fclose(fsttxt);
        case 7
            fclose(fsttxt);
        otherwise
    end
end

if secondopts{2} == 1
    switch secondopts{1}
        case 2
            fclose(sndtxt);
        case 3
        case 4
        case 5
            fclose(sndtxt);
        case 6
            name = System.IO.DirectoryInfo(fopen(sndtxt)).FullName;
            fclose(sndtxt);
            fopen(name,'r+');
            fprintf('form_liczb\t typ_analizy\t l_formantów\t nazwa_mat\t cz_pr\t l_prob\n');
            fprintf(sndtxt,'%s\t %d\t %d\t %d\t %s\t %d\t %s\t %d\n\n','Float',Fs,samples,Spf,'LPC',secondopts{2},get(handles.filetext,'String'),it-1);
            fclose(sndtxt);
        case 7
            fclose(sndtxt);
        otherwise
    end
end

if thirdopts{2} == 1
    switch secondopts{2}
        case 2
            fclose(trdtxt);
        case 3
        case 4
        case 5
            fclose(trdtxt);
        case 6
            name = System.IO.DirectoryInfo(fopen(trdtxt)).FullName;
            fclose(trdtxt);
            fopen(name,'r+');
            fprintf('form_liczb\t typ_analizy\t l_formantów\t nazwa_mat\t cz_pr\t l_prob\n');
            fprintf(trdtxt,'%s\t %d\t %d\t %d\t %s\t %d\t %s\t %d\n\n','Float',Fs,samples,Spf,'LPC',thirdopts{2},get(handles.filetext,'String'),it-1);
            fclose(trdtxt);
        case 7
            fclose(trdtxt);
        otherwise
    end
end
