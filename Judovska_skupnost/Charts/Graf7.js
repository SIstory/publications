$(function () {
        $('#chart7').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Tuji in jugoslovanski državljani med Judi (leta 1937) in celotnim prebivalstvom Dravske banovine (leta 1931)'
            },
            xAxis: {
                categories: ['prebivalstvo Dravske banovine', 'Judje iz Dravske banovine', 'Judje iz Prekmurja', 'Judje iz Dravske banovine brez Prekmurja']
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
                name: 'jugoslovanski državljani',
                data: [1127150, 583, 387, 196]
            }, {
                name: 'tuji državljani',
                data: [17148, 195, 30, 165]
            }]
        });
    });
