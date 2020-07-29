function [filtered_image] = standard_mean_filter(image, selected_window_size)

    tic

    % Set windows paramters
    window = selected_window_size;
    window_increment = floor(window / 2);

    % Read the image into an array
    original_image = imread(image);
    original_image = double(original_image);
    imshow(uint8(original_image));

    % Create a padded array of the image
    padded_original_image = padarray(original_image,[floor((window + 1)/2) floor((window + 1)/2)], 0, 'pre');
    padded_original_image = padarray(original_image, [ceil((window - 1)/2) ceil((window - 1)/2)], 0, 'post');
    padded_original_image = double(padded_original_image);

    % Identify the number of rows and columns of the image
    [rows, columns] = size(padded_original_image);

    % Create a zero array that will contain the new filtered image
    % Use double so that the pixel value isn't clipped at 256
    filtered_image = zeros(rows, columns);
    filtered_image = double(filtered_image);

    % Nested for loop to run through all of the pixels
    for i = window_increment + 1 : rows - window_increment

        for j = window_increment + 1 : columns - window_increment

            % Set the current pixel summation to 0
            pixel_sum = 0;
            pixel_sum = double(pixel_sum);

            % Another nested for loop to run through the pixels in the window
            for ii = i - window_increment : i + window_increment

                for jj = j - window_increment : j + window_increment

                    % Sum the greyscale values of each pixel into new image
                    pixel_sum = pixel_sum + padded_original_image(ii,jj);

                end

            end

            % Set the filtered image to be the mean
            filtered_image(i,j) = pixel_sum / (window^2);
            %filtered_image(i,j) = mean2(padded_original_image(i - window_increment:i + window_increment, j - window_increment:j + window_increment));

        end

    end

    % Use conv2 as reference
    convolution = conv2(padded_original_image, ones(3)/9, 'same');
    difference = convolution - filtered_image;

    % Convert back to uint8 so each image can be displayed
    filtered_image = uint8(filtered_image);
    padded_original_image = uint8(padded_original_image);
    difference = uint8(difference);
    
    toc

end
