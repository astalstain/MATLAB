function [filtered_image] = adaptive_weighted_median_filter(image, selected_window_size)

    % Set windows paramters
    window = selected_window_size;
    window_increment = floor(window / 2);
    centre_weight_value = 100;
    c = 10;
    centre_weight = 3;


    % Create array containing the weighted mask
    weighted_mask = ones(window, window);
    % Set the centre value of mask to be centre_weight (can re-use due to the 
    % window being square
    centre_position = ceil(window/2);
    weighted_mask(centre_position, centre_position) = centre_weight;

    % Read the image into an array
    original_image = imread(image);
    original_image = double(original_image);

    % Create a padded array of the image
    padded_original_image = padarray(original_image,[floor((window + 1)/2) floor((window + 1)/2)], 0, 'pre');
    padded_original_image = padarray(original_image, [ceil((window - 1)/2) ceil((window - 1)/2)], 0, 'post');
    padded_original_image = double(padded_original_image);
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

            % Reset the window median to 0
            window_median = 0;
            window_median = double(window_median);

            % Create sort array to for sorting for each window
            sort_array = zeros(2, window^2);
            sort_array = double(sort_array);

            % Create distance mask
            distance_mask = zeros(1, window^2);
            distance_mask = double(distance_mask);

            % Create distance mask
            weights_mask = zeros(1, window^2);
            weights_mask = double(weights_mask);

            % Reset the counter
            counter = 1;

            % Another nested for loop to run through the pixels in the window
            for ii = i - window_increment : i + window_increment

                for jj = j - window_increment : j + window_increment

                    % Set the local_window element to the pixel value
                    local_window(counter) = padded_original_image(ii, jj);

                    % Select the centre pixel
                    centre_pixel_position = [i, j];

                    % Run through each pixel in window and calculate it's
                    % guassian mask weight
                    x_distance = abs(centre_pixel_position(1) - ii);
                    y_distance = abs(centre_pixel_position(2) - jj);
                    euclidian_distance = sqrt(x_distance^2 + y_distance^2);

                    % Create a distance array
                    distance_mask(counter) = euclidian_distance;

                    % Iterate the couter to allow population of the vector
                    counter = counter + 1;

                end

            end

            % Calculate standard deviation of the window
            window_sigma = std(local_window, 0, 'all');

            % Calculate the mean of the window
            window_mean = mean2(local_window);

            % Calculate the weights array for the window by looping through 
            % the local_window array, distance array
            for x = 1 : window^2

                weights_mask(x) = centre_weight_value - ( (c * distance_mask(x) * window_sigma) / window_mean);

            end

            % Populate the sort array with weights and pixel intensities
            sort_array(1, :) = (local_window(:))';
            sort_array(2, :) = weights_mask;

            % Find the median of the weights_mask
            weights_mask_median = median(weights_mask);

            % Reset the summation
            cummulative_summation = 0;
            cummulative_summation = double(cummulative_summation);

            % Create a for loop to cycle around all of the values in the
            % weight mask arrays
            for p = 1 : size(window^2)

                % Add to the cummulative summation
                cummulative_summation = cummulative_summation + weights_mask(p);

                % Set the current intensity value
                current_intensity = local_window(p);

                % If the median is in this bracket, break out of loop
                if cummulative_summation <= weights_mask_median
                    break;
                end

            end

            % Set the current pixel value in filtered image to this
            % intensity value
            filtered_image(i, j) = current_intensity;

        end

    end

    % Convert back to uint8 so each image can be displayed
    filtered_image = uint8(filtered_image);
    padded_original_image = uint8(padded_original_image);

end