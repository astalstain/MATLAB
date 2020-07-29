function [filtered_image] = truncated_median_filter(image, selected_window_size, centre_weight)

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

    % Reset the local_window_median = 0
    local_window_median = 0;
    local_window_median = double(local_window_median);

    % Nested for loop to run through all of the pixels
    for i = window_increment + 1 : rows - window_increment

        for j = window_increment + 1 : columns - window_increment

            % Reset the window median to 0
            local_window_median = 0;
            local_window_median = double(local_window_median);

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

            % Calcuate the number of entries in the local window
            size_local_window = size(local_window);
            entries_local_window = size_local_window(2);

            % Find the median of the local window
            local_window_median = median(local_window);

            % Calculate distance from highest value
            local_window_max = max(local_window);
            max_difference = local_window_max - local_window_median;

            % Calculate distance from the lowest value
            local_window_min = min(local_window);
            min_difference = local_window_median - local_window_min;

            % While loop which keeps truncating until max_difference ==
            % min_difference

            while max_difference ~= min_difference

                % Identify which of the differences is the smallest - closest to
                % the mode - and then identify which way to truncate

                % If the median is closer to the max value
                if (min(max_difference, min_difference)) == max_difference

                    % If mode is closest to the max value
                    max_cut_off = local_window_median - max_difference;

                    % Preload the while loop to start at index 1
                    x = 1;

                    while x <= entries_local_window

                        % Get rid of values that are below max cut off
                        if local_window(x) < max_cut_off

                            local_window(x) = [];

                        end

                        % Recalculate the size of the local window
                        size_local_window = size(local_window);
                        entries_local_window = size_local_window(2);                    

                        % Iterate x
                        x = x + 1;

                    end

                % If the median is closer to the min value
                else

                    % If mode is closest to the min value
                    min_cut_off = local_window_median + min_difference;

                    % Preload the while loop to start at index 1
                    x = 1;

                    while x <= entries_local_window

                        % Get rid of values that are below max cut off
                        if local_window(x) > min_cut_off

                            local_window(x) = [];

                        end

                        % Recalculate the size of the local window
                        size_local_window = size(local_window);
                        entries_local_window = size_local_window(2);                    

                        % Iterate x
                        x = x + 1;

                    end


                end

                % Recalculate the medain, min diff and max diff (same code as
                % before the while loop)
                local_window_median = median(local_window);
                local_window_max = max(local_window);
                max_difference = local_window_max - local_window_median;
                local_window_min = min(local_window);
                min_difference = local_window_median - local_window_min;


            end


            % Set the filtered image to be the median of the truncated window
            filtered_image(i, j) = local_window_median;



        end

    end

    % Convert back to uint8 so each image can be displayed
    filtered_image = uint8(filtered_image);
    
end

