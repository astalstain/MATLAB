function [filtered_image] = standard_median_filter(image, selected_window_size)

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
            local_window = zeros(1, window^2);
            local_window = double(local_window);
            % Reset the window median to 0
            window_median = 0;
            window_median = double(window_median);
            % Reset the counter
            counter = 1;

            % Another nested for loop to run through the pixels in the window
            for ii = i - window_increment : i + window_increment

                for jj = j - window_increment : j + window_increment

                    % Set the local_window element to the pixel value
                    local_window(counter) = padded_original_image(ii, jj);
                    % Iterate the couter to allow population of the vector
                    counter = counter + 1;

                end

            end

            if(ii == 3 && jj == 3)
                local_window;
            end


            % Turn the window into a vector to be sorted
            window_median_vector = local_window(:);
            % Sort the vector
            sorted_window_median_vector = sort(window_median_vector, 1, 'descend');
            % Find the median of the sorted vector
            window_median = median(sorted_window_median_vector);
            % Set the current pixel value in filtered image to this
            % median value
            filtered_image(i, j) = window_median;

        end

    end

    % Use medfilt2 as reference
    matlab_filter = double(medfilt2(padded_original_image, [3 3]));
    % Subtract filtered image from MATLABs filter to assess performance
    %difference = matlab_filter - filtered_image;
    difference = padded_original_image - filtered_image;

    % Convert back to uint8 so each image can be displayed
    filtered_image = uint8(filtered_image);
    padded_original_image = uint8(padded_original_image);
    matlab_filter = uint8(matlab_filter);
    difference = uint8(difference);

end