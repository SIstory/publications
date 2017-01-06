$(function () {
        $('#table12').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Državljanstvo Judov v Dravski banovini leta 1937'
            },
            xAxis: {
                categories: ['Judje iz Prekmurja', 'Judje iz Dravske banovine brez Prekmurja', 'Judje iz Dravske banovine']
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
                name: 'avstrijsko',
                data: [1, 37, 38]
            }, {
                name: 'brez državljanstva',
                data: [7, 4, 11]
            }, {
                name: 'češkoslovaško',
                data: [2, 52, 54]
            }, {
                name: 'italijansko',
                data: [0, 1, 1]
            }, {
                name: 'jugoslovansko',
                data: [387, 196, 583]
            }, {
                name: 'madžarsko',
                data: [15, 16, 31]
            }, {
                name: 'nemško',
                data: [0, 19, 19]
            }, {
                name: 'poljsko',
                data: [0, 31, 31]
            }, {
                name: 'romunsko',
                data: [0, 2, 2]
            }, {
                name: 'rusko',
                data: [0, 2, 2]
            }, {
                name: 'ostali svet',
                data: [0, 1, 1]
            }, {
                name: 'neznano',
                data: [5, 0, 5]
            }]
        });
    });
