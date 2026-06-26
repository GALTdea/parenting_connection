import { Controller } from "@hotwired/stimulus"

const MAX_BYTES = 100 * 1024 * 1024
const MAX_SECONDS = 15 * 60

export default class extends Controller {
  static targets = [
    "startButton",
    "stopButton",
    "removeButton",
    "fileInput",
    "durationInput",
    "audio",
    "status",
    "timer"
  ]

  connect() {
    this.mediaRecorder = null
    this.recordedChunks = []
    this.startedAt = null
    this.timerInterval = null
    this.stopTimeout = null

    this.updateControls(false)

    if (!this.canRecord()) {
      this.setStatus("Recording is not available in this browser. You can upload an audio file instead.")
      this.startButtonTarget.disabled = true
    }
  }

  disconnect() {
    this.stopTimer()
    this.stopTracks()
  }

  async start() {
    if (!this.canRecord()) return

    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
      this.recordedChunks = []
      this.mediaRecorder = new MediaRecorder(stream)
      this.mediaRecorder.addEventListener("dataavailable", (event) => this.captureChunk(event))
      this.mediaRecorder.addEventListener("stop", () => this.finishRecording())
      this.mediaRecorder.start()
      this.startedAt = Date.now()
      this.startTimer()
      this.stopTimeout = window.setTimeout(() => this.stop(), MAX_SECONDS * 1000)
      this.updateControls(true)
      this.setStatus("Recording. Stop when the moment is captured.")
    } catch (_error) {
      this.setStatus("Microphone permission is needed before recording. You can still upload an audio file.")
      this.updateControls(false)
    }
  }

  stop() {
    if (!this.mediaRecorder || this.mediaRecorder.state === "inactive") return

    this.mediaRecorder.stop()
    this.stopTimer()
    this.updateControls(false)
  }

  remove() {
    this.fileInputTarget.value = ""
    this.durationInputTarget.value = ""
    this.audioTarget.removeAttribute("src")
    this.audioTarget.load()
    this.audioTarget.hidden = true
    this.removeButtonTarget.hidden = true
    this.setStatus("Voice recording removed.")
  }

  fileSelected() {
    const file = this.fileInputTarget.files[0]

    if (!file) {
      this.remove()
      return
    }

    if (file.size > MAX_BYTES) {
      this.remove()
      this.setStatus("Choose an audio file that is 100 MB or smaller.")
      return
    }

    this.previewFile(file)
  }

  captureChunk(event) {
    if (event.data.size > 0) this.recordedChunks.push(event.data)
  }

  finishRecording() {
    this.stopTracks()

    const durationSeconds = this.recordingDuration()
    const type = this.mediaRecorder?.mimeType || "audio/webm"
    const blob = new Blob(this.recordedChunks, { type })

    if (durationSeconds > MAX_SECONDS) {
      this.setStatus("Recordings can be up to 15 minutes.")
      return
    }

    if (blob.size > MAX_BYTES) {
      this.setStatus("Recordings can be up to 100 MB.")
      return
    }

    const file = new File([blob], this.recordingFilename(type), { type })
    const transfer = new DataTransfer()
    transfer.items.add(file)
    this.fileInputTarget.files = transfer.files
    this.durationInputTarget.value = Math.ceil(durationSeconds)
    this.previewFile(file)
    this.setStatus("Voice recording ready. Listen before saving.")
  }

  previewFile(file) {
    const objectUrl = URL.createObjectURL(file)
    this.audioTarget.src = objectUrl
    this.audioTarget.hidden = false
    this.removeButtonTarget.hidden = false

    this.audioTarget.addEventListener("loadedmetadata", () => {
      if (Number.isFinite(this.audioTarget.duration)) {
        this.durationInputTarget.value = Math.ceil(this.audioTarget.duration)
      }
    }, { once: true })
  }

  canRecord() {
    return Boolean(navigator.mediaDevices?.getUserMedia && window.MediaRecorder && window.DataTransfer)
  }

  updateControls(recording) {
    this.startButtonTarget.disabled = recording || !this.canRecord()
    this.stopButtonTarget.disabled = !recording
  }

  startTimer() {
    this.stopTimer()
    this.timerTarget.textContent = "0:00"
    this.timerInterval = window.setInterval(() => {
      this.timerTarget.textContent = this.formatDuration(this.recordingDuration())
    }, 500)
  }

  stopTimer() {
    if (this.timerInterval) window.clearInterval(this.timerInterval)
    if (this.stopTimeout) window.clearTimeout(this.stopTimeout)
    this.timerInterval = null
    this.stopTimeout = null
  }

  stopTracks() {
    this.mediaRecorder?.stream?.getTracks().forEach((track) => track.stop())
  }

  recordingDuration() {
    if (!this.startedAt) return 0

    return (Date.now() - this.startedAt) / 1000
  }

  formatDuration(totalSeconds) {
    const minutes = Math.floor(totalSeconds / 60)
    const seconds = Math.floor(totalSeconds % 60).toString().padStart(2, "0")
    return `${minutes}:${seconds}`
  }

  recordingFilename(type) {
    const extension = type.includes("mp4") ? "m4a" : "webm"
    const timestamp = new Date().toISOString().replace(/[:.]/g, "-")
    return `voice-memory-${timestamp}.${extension}`
  }

  setStatus(message) {
    this.statusTarget.textContent = message
  }
}
