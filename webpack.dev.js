var path = require("path");
var webpack = require("webpack");

module.exports = {
  entry: { sonar: "./web/static/index.js" },
  output: {
    path: path.resolve(__dirname, "priv/static"),
    publicPath: "http://localhost:8080/",
    filename: "js/[name].js"
  },
  resolve: {
    alias: {
      assets: path.resolve(__dirname, "web/static/assets")
    }
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: "vue-loader",
        options: {
          preserveWhitespace: false
        }
      },
      { test: /\.css$/, use: ["style-loader", "css-loader"] },
      {
        test: /\.(png|jpg|gif|svg|woff|ttf)/,
        loader: "url-loader",
        options: { name: "assets/[name].[ext]" }
      },
      {
        test: /\.js$/,
        loader: "buble-loader",
        options: { objectAssign: "Object.assign" }
      }
    ]
  },
  devServer: { clientLogLevel: "none", historyApiFallback: true }
};
