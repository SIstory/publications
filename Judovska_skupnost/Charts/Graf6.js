$(function () {
        $('#chart6').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Poklicna razdelitev judovskega (leta 1937) in celotnega prebivalstva (leta 1931) Ljubljane, Maribora, Ptuja, Celja ter Prekmurja v %'
            },
            xAxis: {
                categories: ['Ljubljana (Judje)', 'Ljubljana (vsi)', 'Maribor (Judje)', 'Maribor (vsi)', 'Ptuj (Judje)', 'Ptuj (vsi)', 'Celje (Judje)', 'Celje (vsi)', 'Prekmurje (Judje)', 'Prekmurje (vsi)']
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
                name: 'A - kmetijstvo, gozdarstvo in ribolov',
                data: [0, 3, 0, 3, 0, 4, 0, 2, 1, 88]
            }, {
                name: 'B - industrija in obrt',
                data: [17, 27, 49, 31, 7, 32, 29, 31, 12, 7]
            }, {
                name: 'C - trgovina, denarništvo in promet',
                data: [44, 24, 34, 28, 90, 18, 52, 21, 60, 2]
            }, {
                name: 'D - javna služba, svobodni poklici in vojska',
                data: [13, 23, 12, 18, 0, 22, 19, 28, 8, 2]
            }, {
                name: 'E - drugi poklici, brez poklica in brez oznake poklica',
                data: [25, 23, 6, 21, 3, 24, 0, 18, 19, 1]
            }]
        });
    });
