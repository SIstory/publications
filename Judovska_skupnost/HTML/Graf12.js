$(function () {
        $('#chart12').highcharts({
            title: {
                text: 'Slovenske in judovske žrtve druge svetovno vojne v Prekmurju glede na datum rojstva'
            },
            xAxis: {
                categories: ['1845/9', '1850/4', '1855/9', '1860/4', '1865/9', '1870/4', '1875/9', '1880/4', '1885/9', '1890/4', '1895/9', '1900/4', '1905/9', '1910/4', '1915/9', '1920/4', '1925/9', '1930/4', '1935/9', '1940/3']
            },
            yAxis: {
                title: {
                    text: 'Število žrtev'
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
                name: 'judovske žrtve',
                data: [1, 0, 3, 11, 14, 20, 30, 35, 33, 30, 29, 35, 29, 29, 18, 14, 17, 16, 13, 11]
            }, {
                name: 'slovenske žrtve',
                data: [0, 0, 1, 3, 5, 9, 14, 27, 22, 18, 40, 46, 62, 77, 90, 149, 46, 16, 12, 12]
            }]
        });
    });
