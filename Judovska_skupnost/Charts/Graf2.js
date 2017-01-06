$(function () {
        $('#chart2').highcharts({
            chart: {
                type: 'area'
            },
            title: {
                text: 'Število Judov v mejah ozemlja Dravske banovine med leti 1880 in 1937'
            },
            xAxis: {
                categories: ['1880', '1890', '1900', '1910', '1921', '1931', '1937'],
                tickmarkPlacement: 'on',
                title: {
                    enabled: false
                }
            },
            yAxis: {
                title: {
                    text: 'Število Judov'
                }
            },
            credits: { 
                enabled: false 
            },
            tooltip: {
                shared: true
            },
            plotOptions: {
                area: {
                    stacking: 'normal',
                    lineColor: '#ffffff',
                    lineWidth: 1,
                    marker: {
                        lineWidth: 1,
                        lineColor: '#ffffff'
                    }
                }
            },
            series: [{
                name: 'ostala Dravska banovina',
                data: [239, 281, 322, 334, 312, 344, 361]
            }, {
                name: 'Prekmurje',
                data: [1082, 1027, 919, 976, 624, 476, 417]
            }]
        });
    });
