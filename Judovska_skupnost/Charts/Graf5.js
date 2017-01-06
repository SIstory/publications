$(function () {
        $('#chart5').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Starostna struktura judovskega prebivalstva v Dravski banovini leta 1937 v primerjavi s celotnim prebivalstvom leta 1931 v %'
            },xAxis: {
                categories: ['0 do 10', '11 do 19', '20 do 29', '30 do 39', '40 do 49', '50 do 59', '60 do 69', '70 do 79', '80 do 89', 'neznano']
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
                headerFormat: '<span style="font-size:10px">{point.key} let starosti</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y} %</b></td></tr>',
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
                name: 'prebivalstvo Dravske banovine',
                data: [25, 15, 18, 13, 10, 8, 7, 3, 1, 0]
            }, {
                name: 'Judje Dravske banovine',
                data: [9, 12, 14, 15, 15, 13, 10, 4, 2, 4]
            }, {
                name: 'Judje v Prekmurju',
                data: [10, 11, 14, 15, 12, 16, 13, 6, 2, 1]
            }, {
                name: 'Judje v ostali Dravski banovini',
                data: [9, 14, 14, 16, 19, 10, 7, 2, 1, 9]
            }]
        });
    });
