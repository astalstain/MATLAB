function [filtered_image] = optimised_median_filter(image, selected_window_size)

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

    % Reset the window median to 0
    window_median = 0;
    window_median = double(window_median);

    % Set the previous_first_column
    previous_first_column = zeros(window, 1);
    previous_first_column = double(previous_first_column);

    % DEBUGGING
    debugging_counter = 0;

    % Nested for loop to run through all of the pixels
    for i = window_increment + 1 : rows - window_increment

        for j = window_increment + 1 : columns - window_increment

            % Set the current pixel summation to 0
            local_window = zeros(1, window^2);
            local_window = double(local_window);

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


            % Covert the window back into a window x window array to make column
            % referenceing easier
            local_window = reshape(local_window, window, window);

            % Take the transpose to get into the correct orientation 
            local_window = local_window';

            % Set the current last column
            local_window_last_column = local_window(:, window);

            % Start each row off with the median of the current window
            if j == window_increment + 1 




                local_window = local_window';
                local_window = reshape(local_window, 1, window^2);

                            % Set the median of the local window
                window_median = median(local_window, 'all');

    %             % Find the position in the current local window where the
    %             % previous median is located
    %             previous_window_median_position = find(local_window == window_median);
    %             
    %             % Calcualte size of previous_window_median_position
    %             position_size_checker = size(previous_window_median_position);
    %             
    %             % If there are repeats, just take the second returned value
    %             if position_size_checker(2) > 1
    %                 
    %                 previous_window_median_position_edited = previous_window_median_position(2);
    %                 
    %             else
    %                 previous_window_median_position_edited = previous_window_median_position;
    %             end

                [unknown previous_window_median_position_edited] = min(abs(local_window - median(local_window, 'all')));

                % Reverse the transpose so that it can be used again in the
                % algorithm
                local_window = local_window';


            % If it's not the start of the row, calculate new median using LTM
            % method
            else

                % Reset the ltm variable
                ltm = 0;

                % Cycle through the previous first column and add 1 if ltm is
                % less that the previous median value

                for x = 1 : window

                    if previous_first_column(x) < window_median

                        ltm = ltm + 1;

                    end

                end

                % Cycle through the new last column subtract 1 if ltm is less
                % than the previous median value

                for x = 1 : window

                    if local_window_last_column(x) < window_median

                        ltm = ltm - 1;

                    end

                end

                % Transpose and reshape again
                local_window = local_window';
                local_window = reshape(local_window, 1, window^2);



                % Add on the ltm value to the previous median value to get the
                % current median value
                window_median = local_window(previous_window_median_position_edited + ltm);


            end


            % Reshape again
            %local_window = local_window';
            local_window = reshape(local_window, window, window);


            % Set the first column of the local window to be the previous
            % column for the next loop/movement of the window
            previous_first_column = local_window(1, :);

    %         previous_first_column = local_window_last_column;

            % Set the previous window median position to the current window
            % median position for the next iteration of the loop

            % Set the output of the filtered image
            filtered_image(i, j) = window_median;

        end

    end

    % Convert back to uint8 so each image can be displayed
    filtered_image = uint8(filtered_image);
    padded_original_image = uint8(padded_original_image);

    % Display each image on the same figure
    subplot(2,2,1);
    imshow(padded_original_image);
    title('Padded Original Image');

    subplot(2,2,2);
    imshow(filtered_image, []);
    title('Filtered Image');

end