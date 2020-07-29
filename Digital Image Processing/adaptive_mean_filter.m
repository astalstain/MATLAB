function [filtered_image] = adaptive_mean_filter(image, selected_window_size)

    % Set windows paramters
    window = selected_window_size;
    window_increment = floor(window / 2);

    % Read the image into an array
    original_image = imread(image);
    original_image = double(original_image);

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

            % Select the current window array
            window_array = padded_original_image( (i - window_increment) : (i + window_increment), (j - window_increment) : (j + window_increment));

            % Calculate the standard deviation of the window elements
            window_standard_deviation = std2(window_array);

            % Calculate the mean of the window elements
            window_mean = mean2(padded_original_image(i - window_increment:i + window_increment, j - window_increment:j + window_increment));

            % Calculate the SNR (mean in window / standard deviation)
            window_snr = window_mean / window_standard_deviation;

            % Calculate output value
            output = window_mean + ((1 / window_snr)*(padded_original_image(i, j) - window_mean));

            % Set the filtered image to be the output value
            filtered_image(i,j) = output;

        end

    end

    % Use imsharpen as reference
    sharpening_filter = imsharpen(padded_original_image);
    difference = sharpening_filter - filtered_image;

    % Convert back to uint8 so each image can be displayed
    filtered_image = uint8(filtered_image);
    padded_original_image = uint8(padded_original_image);
    difference = uint8(difference);

end
