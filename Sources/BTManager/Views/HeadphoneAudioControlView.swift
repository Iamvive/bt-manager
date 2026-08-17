import SwiftUI

struct HeadphoneAudioControlView: View {
    @ObservedObject var audioControl: AudioControlService
    let device: BluetoothDevice

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header Title
            Text("🎙️ MICROPHONE & AUDIO CONTROLS")
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.secondary)

            // Mic Mute & Sidetone Controls Row
            HStack(spacing: 8) {
                Button(action: { audioControl.toggleMicMute() }) {
                    Label(audioControl.isMicMuted ? "MIC MUTED" : "MUTE MIC", systemImage: audioControl.isMicMuted ? "mic.slash.fill" : "mic.fill")
                        .font(.system(size: 10, weight: .bold))
                }
                .buttonStyle(.borderedProminent)
                .tint(audioControl.isMicMuted ? .red : .green)
                .controlSize(.small)
                .help("Shortcut: Cmd + Option + M")

                Spacer()

                Toggle(isOn: Binding(
                    get: { audioControl.isSidetoneEnabled },
                    set: { _ in audioControl.toggleSidetone() }
                )) {
                    Text("🎧 Sidetone")
                        .font(.system(size: 10, weight: .medium))
                }
                .toggleStyle(.checkbox)
            }

            // Sidetone Volume Slider if enabled
            if audioControl.isSidetoneEnabled {
                HStack(spacing: 6) {
                    Text("Sidetone Vol:")
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)

                    Slider(value: Binding(
                        get: { audioControl.sidetoneVolume },
                        set: { audioControl.setSidetoneVolume($0) }
                    ), in: 0.0...1.0)
                    .controlSize(.mini)
                }
            }

            Divider()

            // Bass Boost Slider
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("🔊 Bass Boost Level")
                        .font(.system(size: 10, weight: .semibold))
                    Spacer()
                    Text(String(format: "+%.1f dB", audioControl.calculatedBassGaindB))
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.blue)
                }

                Slider(value: Binding(
                    get: { audioControl.bassBoostLevel },
                    set: { audioControl.setBassBoostLevel($0) }
                ), in: 0.0...1.0)
                .controlSize(.small)
            }

            // EQ Presets Section
            VStack(alignment: .leading, spacing: 4) {
                Text("🎵 Equalizer Presets")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.secondary)

                HStack(spacing: 4) {
                    ForEach(EQPreset.allPresets) { preset in
                        Button(action: { audioControl.setEQPreset(preset) }) {
                            Text(preset.name)
                                .font(.system(size: 9, weight: audioControl.activeEQPreset == preset ? .bold : .regular))
                        }
                        .buttonStyle(.bordered)
                        .tint(audioControl.activeEQPreset == preset ? .blue : .secondary)
                        .controlSize(.mini)
                    }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(NSColor.controlBackgroundColor))
        )
    }
}
