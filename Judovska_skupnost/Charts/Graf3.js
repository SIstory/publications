$(function () {
        $('#chart3').highcharts({
            chart: {
                type: 'area'
            },
            title: {
                text: 'Prisotno judovsko prebivalstvo z ozemlja Dravske banovine brez Prekmurja po večjih mestih (1880-1937)'
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
                name: 'ostali kraji',
                data: [76, 74, 95, 90, 98, 106, 105]
            }, {
                name: 'Celje',
                data: [10, 6, 23, 25, 26, 30, 21]
            }, {
                name: 'Ptuj',
                data: [41, 54, 37, 37, 28, 32, 29]
            }, {
                name: 'Maribor',
                data: [37, 64, 62, 66, 64, 81, 68]
            }, {
                name: 'Ljubljana',
                data: [75, 83, 105, 116, 96, 95, 138]
            }]
        });
    });
