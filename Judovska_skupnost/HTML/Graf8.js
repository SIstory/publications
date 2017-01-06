$(function () {
        $('#chart8').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Državljanstvo Judov v večjih slovenskih mestih leta 1937'
            },
            xAxis: {
                categories: ['Ljubljana', 'Maribor', 'Ptuj', 'Celje', 'Kranj']
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Odstotki'
                }
            },
            credits: { 
                enabled: false 
            },
            tooltip: {
                pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.percentage:.0f}%)<br/>',
                shared: true
            },
            plotOptions: {
                column: {
                    stacking: 'percent'
                }
            },
                series: [{
                name: 'jugoslovansko',
                data: [62, 37, 27, 13, 5]
            }, {
                name: 'avstrijsko',
                data: [26, 6, 0, 3, 0]
            }, {
                name: 'češkoslovaško',
                data: [11, 20, 0, 0, 11]
            }, {
                name: 'madžarsko',
                data: [10, 0, 0, 0, 0]
            }, {
                name: 'poljsko',
                data: [22, 5, 0, 4, 0]
            }, {
                name: 'ostalo',
                data: [7, 0, 2, 1, 5]
            }]
        });
    });
