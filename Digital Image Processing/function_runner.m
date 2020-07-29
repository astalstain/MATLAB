filtered_image3a = standard_mean_filter('nzjers1.png',3);
filtered_image5a = standard_mean_filter('nzjers1.png',5);
filtered_image7a = standard_mean_filter('nzjers1.png',7);
filtered_image9a = standard_mean_filter('nzjers1.png',9);
filtered_image3b = standard_mean_filter('foetus.png',3);
filtered_image5b = standard_mean_filter('foetus.png',5);
filtered_image7b = standard_mean_filter('foetus.png',7);
filtered_image9b = standard_mean_filter('foetus.png',9);

imwrite(filtered_image3a, 'standard_mean_filter_3a.png');
imwrite(filtered_image5a, 'standard_mean_filter_5a.png');
imwrite(filtered_image7a, 'standard_mean_filter_7a.png');
imwrite(filtered_image9a, 'standard_mean_filter_9a.png');
imwrite(filtered_image3b, 'standard_mean_filter_3b.png');
imwrite(filtered_image5b, 'standard_mean_filter_5b.png');
imwrite(filtered_image7b, 'standard_mean_filter_7b.png');
imwrite(filtered_image9b, 'standard_mean_filter_9b.png');

imwrite(edge(filtered_image3a), 'e_standard_mean_filter_3a.png');
imwrite(edge(filtered_image5a), 'e_standard_mean_filter_5a.png');
imwrite(edge(filtered_image7a), 'e_standard_mean_filter_7a.png');
imwrite(edge(filtered_image9a), 'e_standard_mean_filter_9a.png');
imwrite(edge(filtered_image3b), 'e_standard_mean_filter_3b.png');
imwrite(edge(filtered_image5b), 'e_standard_mean_filter_5b.png');
imwrite(edge(filtered_image7b), 'e_standard_mean_filter_7b.png');
imwrite(edge(filtered_image9b), 'e_standard_mean_filter_9b.png');
