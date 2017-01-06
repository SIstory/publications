$(function () {
        $('#chart16').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Vzrok smrti judovskih in ostalih žrtev druge svetovne vojne v Sloveniji glede na spol'
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
                name: 'oboroženi spopadi',
                data: [24549, 648, 109, 1, 2, 0, 3, 0]
            }, {
                name: 'ubiti med vojno',
                data: [19910, 3846, 167, 47, 10, 3, 0, 0]
            }, {
                name: 'koncentracijska taborišča',
                data: [8617, 2361, 166, 67, 205, 247, 25, 13]
            }, {
                name: 'množični poboji po vojni',
                data: [12973, 434, 2, 0, 0, 0, 0, 0]
            }, {
                name: 'talci',
                data: [3837, 201, 14, 0, 2, 0, 0, 0]
            }, {
                name: 'prisilno delo',
                data: [213, 22, 30, 2, 5, 0, 0, 0]
            }, {
                name: 'izgnanstvo',
                data: [1182, 970, 15, 13, 0, 0, 6, 4]
            }, {
                name: 'zapor',
                data: [744, 135, 34, 2, 0, 0, 0, 0]
            }, {
                name: 'vojno ujetništvo',
                data: [482, 0, 11, 0, 3, 0, 0, 0]
            }, {
                name: 'represalije',
                data: [624, 57, 0, 0, 0, 0, 0, 0]
            }, {
                name: 'bombardiranje',
                data: [1377, 897, 28, 3, 4, 1, 0, 0]
            }, {
                name: 'nesreče',
                data: [1357, 161, 20, 3, 0, 0, 0, 0]
            }, {
                name: 'pogrešane osebe',
                data: [4772, 302, 216, 2, 2, 0, 0, 0]
            }, {
                name: 'neugotovljeno',
                data: [4673, 200, 24, 0, 6, 5, 0, 1]
            }]
        });
    });
