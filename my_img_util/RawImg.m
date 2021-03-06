classdef RawImg<ColorImg
    %TODO: overwrite save 
    % save Raw;
    
    %% Public properties
    properties (GetAccess = public, SetAccess = private)
        path,name,ext
        %data % only store roi data?
        rect%roi
    end
    
    %% Public methods
    methods (Access = public)
        
        function I = RawImg(ImageFile)
			if ~ischar(ImageFile)
				error('Input must be a string specify the path of an image file');
			end
			
			I@ColorImg( imread(ImageFile) ) ;
			[I.path,I.name,I.ext] = fileparts(ImageFile);
        end
        
        function str = file(self)
            str = fullfile(self.path,self.name,self.ext);
        end
        
        function disp(self)
            builtin('disp',self);
            info = imfinfo(self.file);
            disp(info);
        end
		
		function I = togray(I)
			if ~I.isgray()
				I.data = rgb2gray(I.data);
				I.chns = 1;
            end
		end
        
        % selrows
        % selcols
        function ROI = rectroi(I, rect) % rectroi({rows, cols}) cannot use []
            ROI = I.data(rect{:}, :);
            I.rect = rect;
            % obj.roi = axes('position',[0.1,0.1,0.4,0.4]);
        end
		
        function h = imshow(I, varargin)
            % TODO resize downsample cases
            %move axis oxy to oxy of roi, for ploting obj in roi
            if isempty(I.rect)
                h = imshow(I.data, varargin{:});
            else
                xdata = [1 I.cols] - I.rect{2}(1);
                ydata = [1 I.rows] - I.rect{1}(1);
                h = imshow(I.data, 'Xdata',xdata, 'Ydata',ydata, varargin{:});
            end
			
			title([I.name, I.ext],'Interpreter','none');
        end
		
		function [R,G,B] = rgbchn(I)
		% get rgb channel
			R = I.data(:,:,1);
			G = I.data(:,:,2);
			B = I.data(:,:,3);
		end
		
		%% TODO: different kinds of images
		% imoverlay(ROI, Edge, [255, 255, 0])
		function J = roidrawmask(I, mask, color)
			if nargin < 3
				color = 'r';
			end
			
			mask = (mask ~= 0); 
			
			if ~isgray(I)
				[R,G,B] = getChannel(I.data(I.rect{:}, :)); %I.rgbchn();
				switch lower(color)
					case 'r'
						R(mask) = 128;
					case 'g'
						G(mask) = 128;
					case 'b'
						B(mask) = 128;
				end
				
				J = cat(3, R, G, B);
				
				if nargout == 0 
					I.data(I.rect{:}, :) = J;
				end
			end
		end
        
        % 		function ROI = selroi(I, roi)
        % 		% not finished yet
        % 			if nargin == 0
        % 			%TODO
        % 			end
        %
        % 			switch class(roi)
        % 				case 'char'
        % 					switch lower(roi)
        % 						case 'lowhalf'
        % 						%TODO if rawimag is gray
        % 							ROI = I.data(ceil(end/2):end, :, :);
        % 						end
        % 					end
        % 				case 'matlab.graphics.primitive.Rectangle'
        % 					% h = rectangle;
        % 			end
        % 		end
        
        function h = plot(I, varargin)
            h = imshow(I.data, varargin{:});
            title(inputname(1));
        end
        
        function bool = isgray(I)
            bool = (I.chns == 1);
        end
        
        % plot and draw
        % plot over can be removed while draw will change image data.
        % plot is not the responsibility of this obj (axes, figure)
        % draw
        
        function imdata = drawLine(I, lineObj)
        end
        
    end% methods
end% classdef