$(function () {
        $('#chart1').highcharts({
            chart: {
                type: 'area'
            },
            title: {
                text: 'Delež Judov Murske Sobote, Lendave, Beltincev in drugih prekmurskih vasi med leti 1793 in 1937, v %'
            },
            xAxis: {
                categories: ['1778', '1793', '1812', '1836', '1846', '1854', '1880', '1890', '1900', '1910', '1921', '1931', '1937'],
                tickmarkPlacement: 'on',
                title: {
                    enabled: false
                }
            },
            yAxis: {
                title: {
                    text: 'Odstotki'
                }
            },
            credits: { 
                enabled: false 
            },
            tooltip: {
                pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.percentage:.1f}%</b> ({point.y:,.0f})<br/>',
                shared: true
            },
            plotOptions: {
                area: {
                    stacking: 'percent',
                    lineColor: '#ffffff',
                    lineWidth: 1,
                    marker: {
                        lineWidth: 1,
                        lineColor: '#ffffff'
                    }
                }
            },
            series: [{
                name: 'okoliške vasi',
                data: [0, 6, 0, 10, 29, 74, 399, 441, 377, 299, 195, 143, 127]
            }, {
                name: 'Beltinci',
                data: [0, 21, 40, 34, 30, 43, 152, 86, 69, 61, 4, 3, 3]
            }, {
                name: 'Murska Sobota',
                data: [0, 14, 13, 98, 180, 180, 311, 283, 199, 234, 175, 159, 150]
            }, {
                name: 'Lendava',
                data: [14, 19, 23, 69, 82, 162, 220, 217, 274, 382, 250, 171, 137]
            }]
        });
    });
