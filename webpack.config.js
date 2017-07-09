var path = require("path");
var webpack = require("webpack");
var ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
  entry: { sonar: "./web/static/index.js" },
  output: {
    path: path.resolve(__dirname, "priv/static"),
    publicPath: "/",
    filename: "js/[name].js",
    chunkFilename: "js/chunk[id].js"
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
          loaders: {
            css: ExtractTextPlugin.extract({
              loader: "css-loader",
              fallback: "vue-style-loader"
            })
          },
          preserveWhitespace: false
        }
      },
      {
        test: /\.css$/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: "css-loader"
        })
      },
      {
        test: /\.(png|jpg|gif|svg)/,
        loader: "url-loader",
        options: { limit: 8192, name: "images/[name].[ext]" }
      },
      {
        test: /\.(woff|ttf)/,
        loader: "url-loader",
        options: { limit: 8192, name: "fonts/[name].[ext]" }
      },
      {
        test: /\.js$/,
        loader: "buble-loader",
        exclude: /node_modules/,
        options: { objectAssign: "Object.assign" }
      }
    ]
  },
  plugins: [new ExtractTextPlugin("css/[name].css")]
};
