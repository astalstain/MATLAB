function [filtered_image] = guassian_low_pass_filter(image, sigma)

    % Set windows paramters
    mask_dimension = 2 * ceil(3 * sigma) + 1;

    % Create empty mask arrray
    guassian_mask = zeros(1, mask_dimension^2);
    guassian_mask = double(guassian_mask);

    window = mask_dimension;
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

    % Set the current pixel summation to 0
    local_window = zeros(1, window^2);
    local_window = double(local_window);

    % Create a zero array that will contain the new filtered image
    % Use double so that the pixel value isn't clipped at 256
    filtered_image = zeros(rows, columns);
    filtered_image = double(filtered_image);

    % Nested for loop to run through all of the pixels
    for i = window_increment + 1 : rows - window_increment

        for j = window_increment + 1 : columns - window_increment

            % Set the current pixel summation to 0
            total_mask_weight = 0;
            total_mask_weight = double(total_mask_weight);


            % Start the counter to populate the array
            counter = 1;

            % Another nested for loop to run through the pixels in the window
            for ii = i - window_increment : i + window_increment

                for jj = j - window_increment : j + window_increment

                    % Select the centre pixel
                    centre_pixel_position = [i, j];



                    % Run through each pixel in window and calculate it's
                    % guassian mask weight
                    x_distance = abs(centre_pixel_position(1) - ii);
                    y_distance = abs(centre_pixel_position(2) - jj);

                    % Populate the mask with the current pixels weight
                    guassian_mask(counter) = exp( -( (x_distance^2) + (y_distance^2) ) / (2 * sigma^2) );

                    % Create local window of padded_original_image
                    local_window(counter) = padded_original_image(ii, jj);

                    % Add current weight to the total weight
                    total_mask_weight = total_mask_weight + guassian_mask(counter);



                    % Iterate the counter
                    counter = counter + 1;

                end

            end

            % Normalise the guassian mask by dividing each element by the
            % summation of the weights in the mask
            normalised_guassian_mask = guassian_mask / total_mask_weight;

            % Convert 1-D arrays into a N-D arrays for elementwise multiplication
            normalised_guassian_mask = reshape(normalised_guassian_mask, mask_dimension, mask_dimension);
            local_window = reshape(local_window, mask_dimension, mask_dimension);

            % Multiply the current window by the guassian mask to get output
            % (.*)
            total_normalised_mask_weight = normalised_guassian_mask .* local_window;

            % Sum all of the values in the output window to get output pixel
            % value
            output_value = sum(total_normalised_mask_weight, 'all');

            % Set the filtered image to be the mean
            filtered_image(i,j) = output_value;


        end

    end

    % Use imguassfilt as reference 
    guassian_filter = imgaussfilt(padded_original_image, sigma);
    difference = guassian_filter - filtered_image;

    % Convert back to uint8 so each image can be displayed
    filtered_image = uint8(filtered_image);
    padded_original_image = uint8(padded_original_image);
    difference = uint8(difference);
    
end