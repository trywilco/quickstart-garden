module.exports = {
  devServer: {
    disableHostCheck: true,
    public: process.env.HOSTNAME
      ? `https://${process.env.HOSTNAME}-8080.app.github.dev`
      : undefined,
    progress: false,
    proxy: {
      "^/api": {
        target: `https://${process.env.HOSTNAME}-3000.app.github.dev` || "http://api",
        changeOrigin: true,
        secure: false,
        logLevel: "debug",
      },
      "^/socket.io": {
        target: "http://result",
        changeOrigin: true,
        secure: false,
        ws: true,
        logLevel: "debug",
      },
    },
  },
};
