let i, tmp, countData = new Array();
// 1週間分のカウント数を取得
for (i = 0; i < 7; i++) {
  tmp = document.getElementById(i + '_ago').value;
  countData.push(tmp)
}

countData.reverse();

//折れ線グラフ
const ctx = document.getElementById("myLineChart");

const myLineChart = new Chart(ctx, {
  //グラフの種類
  type: 'line',
  //データの設定
  data: {
    //データ項目のラベル
    labels: ["6日前", "5日前", "4日前", "3日前", "2日前", "1日前", "今日"],
    //データセット
    datasets: [{
      //凡例
      label: "投稿した本の数",
      //背景色
      backgroundColor: "rgba(75,192,192,0.4)",
      //枠線の色
      borderColor: "rgba(75,192,192,1)",
      //グラフのデータ
      data: countData,
      lineTension: 0.5,
    }]
  },
  //オプションの設定
  options: {
    scales: {
      //縦軸の設定
      yAxes: [{
        ticks: {
          //最小値を0にする
          beginAtZero: true
        }
      }]
    }
  }
});