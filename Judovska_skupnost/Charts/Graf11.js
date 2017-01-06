$(function () {
        $('#chart11').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Poklicna struktura prebivalstva jugoslovanske Slovenije iz leta 1931, Judovskega prebivalstva iz leta 1937 ter judovskih in slovenskih žrtev druge svetovne vojne'
            },
            xAxis: {
                categories: ['Slovenija (vsi 1931)',
                             'Slovenija (žrtve)',
                             'Prekmurje (vsi 1931)',
                             'Prekmurje (vse žrtve)',
                             'Prekmurje (Judje 1937)',
                             'Prekmurje (judovske žrtve)',
                             'Slovenija brez Prekmurja (Judje 1937)',
                             'Slovenija brez Prekmurja (judovske žrtve)']
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
                name: 'A - kmetijstvo in gozdarstvo',
                data: [689772, 17095, 79488, 255, 4, 3, 0, 0]
            }, {
                name: 'B - obrt in industrija',
                data: [253444, 27916, 6025, 110, 49, 41, 110, 16]
            }, {
                name: 'C - trgovina, denarništvo in promet',
                data: [78042, 3564, 1705, 29, 251, 190, 147, 22]
            }, {
                name: 'D - javne službe in svobodni poklici',
                data: [53094, 3900, 2143, 72, 35, 22, 40, 5]
            }, {
                name: 'E - drugi poklici, brez poklica, brez oznake poklica',
                data: [69946, 4335, 1356, 39, 78, 54, 64, 7]
            }]
        });
    });
