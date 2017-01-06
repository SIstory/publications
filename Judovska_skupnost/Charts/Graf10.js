$(function () {
        $('#chart10').highcharts({
            title: {
                text: 'Gibanje števila judovskega prebivalstva od njihove naselitve do holokavsta z ozirom na posamezna okupirana ozemlja Slovenije med drugo svetovno vojno'
            },
            xAxis: {
                categories: [1778, 1793, 1812, 1836, 1846, 1854, 1869, 1880, 1890, 1900, 1910, 1921, 1931, 1937, 1940, 1941, 1942, 1944, 1945, 1946]
            },
            yAxis: {
                title: {
                    text: 'Število Judov'
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            credits: { 
                enabled: false 
            },
            series: [{
                name: 'madžarsko okupacijsko območje',
                data: [14, 60, 76, 211, 321, 459, 700, 1082, 1027, 919, 976, 624, 476, 417, 420, 438, 450, 476, 13, 80]
            }, {
                name: 'italijansko okupacijsko območje',
                data: [0, 0, 0, 0, 0, 0, 20, 79, 87, 131, 132, 96, 115, 145, 165, 550, 50, 32, 0, 50]
            }, {
                name: 'nemško okupacijsko območje',
                data: [0, 0, 0, 0, 0, 6, 68, 160, 194, 191, 202, 216, 229, 216, 260, 50, 2, 2, 2, 70]
            }]
        });
    });
