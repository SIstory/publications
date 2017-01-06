$(function () {
        $('#chart14').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Spol judovskih in ostalih žrtev druge svetovne vojne v Sloveniji; v %'
            },
            xAxis: {
                categories: ['Slovenija',
                             'Prekmurje (Slovenci)',
                             'Prekmurje (Judje)',
                             'Slovenija brez Prekmurja (Judje)']
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
                name: 'moški',
                data: [85313, 836, 193, 34]
            }, {
                name: 'ženske',
                data: [10236, 140, 214, 18]
            }]
        });
    });
