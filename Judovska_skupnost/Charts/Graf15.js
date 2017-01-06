$(function () {
        $('#chart15').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Deleži judovskih in ostalih civilnih žrtev druge svetovne vojne v Sloveniji glede na spol; v %'
            },
            xAxis: {
                categories: ['Slovenija (moški)',
                             'Slovenija (ženske)',
                             'Prekmurje (Slovenci moški)',
                             'Prekmurje (Slovenci ženske)',
                             'Prekmurje (Judje moški)',
                             'Prekmurje (Judje ženske)',
                             'Slovenija brez Prekmurja (Judje moški)',
                             'Slovenija brez Prekmurja (Judje ženske)']
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
                name: 'civilisti',
                data: [15791, 6784, 133, 103, 203, 230, 31, 18]
            }, {
                name: 'borci',
                data: [59308, 1786, 339, 3, 8, 0, 3, 0]
            }]
        });
    });
