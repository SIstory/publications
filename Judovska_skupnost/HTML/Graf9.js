$(function () {
        $('#chart9').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Odstotek žrtev druge svetovne vojne v Sloveniji'
            },xAxis: {
                categories: ['Judje (Prekmurje)', 
                             'Judje (Slovenija brez Prekmurja',
                             'Slovenija',
                             'Ljubljanska pokrajina',
                             'Gorenjska',
                             'Primorska',
                             'Spodnja Štajerska',
                             'Prekmurje']
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Odstotki'
                }
            },
            legend: {
                enabled: false
            },
            credits: { 
                enabled: false 
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f} %</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [{
                name: '% smrtnih žrtev',
                data: [84, 16, 6.4, 9.5, 7.2, 4.9, 4.7, 1.1]
            }]
        });
    });
