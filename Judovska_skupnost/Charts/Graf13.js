$(function () {
        $('#chart13').highcharts({
            title: {
                text: 'Leto rojstva judovskih žrtev holokavsta in preživelih Judov iz Prekmurja; št.'
            },
            xAxis: {
                categories: ['1845/9', '1850/4', '1855/9', '1860/4', '1865/9', '1870/4', '1875/9', '1880/4', '1885/9', '1890/4', '1895/9', '1900/4', '1905/9', '1910/4', '1915/9', '1920/4', '1925/9', '1930/4', '1935/9', '1940/3']
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
                name: 'preživeli',
                data: [0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 6, 5, 10, 7, 8, 12, 2, 0, 1]
            }, {
                name: 'žrtve',
                data: [1, 0, 3, 11, 14, 20, 30, 35, 33, 30, 29, 35, 29, 29, 18, 14, 17, 16, 13, 11]
            }]
        });
    });
