import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from statsmodels.tsa.arima_process import ArmaProcess
import warnings
import yasir_acw

def generate_white_noise(n_samples, fs=1000, seed=42):
    """Generate white noise signal"""
    np.random.seed(seed)
    return np.random.randn(n_samples), fs

def generate_ar1_process(n_samples, phi=0.8, fs=1000, seed=42):
    """Generate AR(1) process with known autocorrelation decay"""
    np.random.seed(seed)
    ar = np.array([1, -phi])
    ma = np.array([1])
    arma_process = ArmaProcess(ar, ma)
    return arma_process.generate_sample(nsample=n_samples), fs

def generate_sinusoidal(n_samples, freq=10, fs=1000, phase=0, noise_level=0):
    """Generate sinusoidal signal with optional noise"""
    t = np.arange(n_samples) / fs
    signal_clean = np.sin(2 * np.pi * freq * t + phase)
    if noise_level > 0:
        np.random.seed(42)
        noise = np.random.randn(n_samples) * noise_level
        return signal_clean + noise, fs
    return signal_clean, fs

def generate_step_function(n_samples, step_position=0.5, fs=1000):
    """Generate step function"""
    step_idx = int(step_position * n_samples)
    signal_data = np.zeros(n_samples)
    signal_data[step_idx:] = 1.0
    return signal_data, fs

def generate_exponential_decay(n_samples, tau, fs=1000, A=1.0, B=0.0):
    """Generate exponential decay for validation"""
    t = np.arange(n_samples) / fs
    return A * np.exp(-t / tau) + B, fs

class TestACWAnalysis:
    def __init__(self):
        self.test_results = {}
        
    def test_white_noise(self):
        """Test ACW measures on white noise - should have very short correlations"""
        print("Testing white noise...")
        signal_data, fs = generate_white_noise(5000, fs=1000)
        
        acw_50, acw_0, acw_integral, acw_1_over_e, tau = yasir_acw.calc_int(signal_data, fs)
        
        # White noise should have very small ACW values
        assert acw_50 < 0.01, f"ACW_50 too large for white noise: {acw_50}"
        assert acw_integral < 0.01, f"ACW integral too large for white noise: {acw_integral}"
        
        print(f"  White noise results: ACW_50={acw_50:.4f}, ACW_0={acw_0:.4f}, "
              f"ACW_integral={acw_integral:.4f}, ACW_1/e={acw_1_over_e:.4f}, tau={tau:.4f}")
        
        self.test_results['white_noise'] = {
            'acw_50': acw_50, 'acw_0': acw_0, 'acw_integral': acw_integral,
            'acw_1_over_e': acw_1_over_e, 'tau': tau
        }
        
    def test_ar1_process(self):
        """Test ACW measures on AR(1) process with known properties"""
        print("Testing AR(1) process...")
        phi_values = [0.5, 0.8, 0.95]
        
        for phi in phi_values:
            signal_data, fs = generate_ar1_process(5000, phi=phi, fs=1000)
            acw_50, acw_0, acw_integral, acw_1_over_e, tau = yasir_acw.calc_int(signal_data, fs)
            
            # For AR(1), theoretical tau = -1/ln(phi)
            theoretical_tau = -1 / np.log(phi)
            tau_error = abs(tau - theoretical_tau) / theoretical_tau if not np.isnan(tau) else np.inf
            
            print(f"  AR(1) phi={phi}: ACW_50={acw_50:.4f}, tau={tau:.4f} "
                  f"(theoretical={theoretical_tau:.4f}, error={tau_error:.2%})")
            
            # Store results
            if 'ar1_process' not in self.test_results:
                self.test_results['ar1_process'] = {}
            self.test_results['ar1_process'][phi] = {
                'measured_tau': tau, 'theoretical_tau': theoretical_tau,
                'tau_error': tau_error, 'acw_50': acw_50, 'acw_integral': acw_integral
            }
    
    def test_sinusoidal_signals(self):
        """Test ACW measures on sinusoidal signals"""
        print("Testing sinusoidal signals...")
        frequencies = [1, 5, 20]  # Hz
        
        for freq in frequencies:
            signal_data, fs = generate_sinusoidal(5000, freq=freq, fs=1000)
            acw_50, acw_0, acw_integral, acw_1_over_e, tau = yasir_acw.calc_int(signal_data, fs)
            
            # Expected first zero crossing at 1/(2*freq)
            expected_first_zero = 1 / (2 * freq)
            
            print(f"  Sinusoidal {freq}Hz: ACW_50={acw_50:.4f}, ACW_0={acw_0:.4f} "
                  f"(expected~{expected_first_zero:.4f}), tau={tau:.4f}")
            
            if 'sinusoidal' not in self.test_results:
                self.test_results['sinusoidal'] = {}
            self.test_results['sinusoidal'][freq] = {
                'acw_50': acw_50, 'acw_0': acw_0, 'expected_zero': expected_first_zero,
                'acw_integral': acw_integral, 'tau': tau
            }
    
    def test_sampling_frequency_scaling(self):
        """Test that time-based measures scale correctly with sampling frequency"""
        print("Testing sampling frequency scaling...")
        
        # Generate same AR(1) process at different sampling rates
        phi = 0.8
        fs_values = [500, 1000, 2000]
        n_samples = 5000
        
        results = {}
        for fs in fs_values:
            signal_data, _ = generate_ar1_process(n_samples, phi=phi, fs=fs)
            acw_50, acw_0, acw_integral, acw_1_over_e, tau = yasir_acw.calc_int(signal_data, fs)
            results[fs] = {'acw_50': acw_50, 'acw_0': acw_0, 'tau': tau}
            print(f"  fs={fs}Hz: ACW_50={acw_50:.4f}, tau={tau:.4f}")
        
        # Check that time-based measures are approximately consistent across fs
        taus = [results[fs]['tau'] for fs in fs_values if not np.isnan(results[fs]['tau'])]
        if len(taus) > 1:
            tau_std = np.std(taus)
            tau_mean = np.mean(taus)
            tau_cv = tau_std / tau_mean if tau_mean != 0 else np.inf
            print(f"  Tau consistency across fs: mean={tau_mean:.4f}, CV={tau_cv:.2%}")
        
        self.test_results['fs_scaling'] = results
    
    def test_multichannel_processing(self):
        """Test calc_int_array with multiple channels"""
        print("Testing multi-channel processing...")
        
        n_samples, n_channels = 3000, 5
        fs = 1000
        
        # Create mixed signal types across channels
        ts = np.zeros((n_samples, n_channels))
        signal_types = []
        
        # Channel 0: white noise
        ts[:, 0], _ = generate_white_noise(n_samples, fs)
        signal_types.append('white_noise')
        
        # Channel 1: AR(1)
        ts[:, 1], _ = generate_ar1_process(n_samples, phi=0.8, fs=fs)
        signal_types.append('ar1')
        
        # Channel 2: sinusoidal
        ts[:, 2], _ = generate_sinusoidal(n_samples, freq=10, fs=fs)
        signal_types.append('sinusoidal')
        
        # Channel 3: step function
        ts[:, 3], _ = generate_step_function(n_samples, fs=fs)
        signal_types.append('step')
        
        # Channel 4: exponential decay
        ts[:, 4], _ = generate_exponential_decay(n_samples, tau=0.1, fs=fs)
        signal_types.append('exponential')
        
        # Process all channels
        results = yasir_acw.calc_int_array(ts, fs)
        
        print(f"  Multi-channel results shape: {results.shape}")
        print("  Results by channel:")
        measure_names = ['ACW_50', 'ACW_0', 'ACW_integral', 'ACW_1/e', 'tau']
        
        for i, signal_type in enumerate(signal_types):
            print(f"    Ch{i} ({signal_type}):", end="")
            for j, measure in enumerate(measure_names):
                print(f" {measure}={results[j, i]:.4f}", end="")
            print()
        
        # Verify output shape
        assert results.shape == (5, n_channels), f"Wrong output shape: {results.shape}"
        
        self.test_results['multichannel'] = {
            'results': results,
            'signal_types': signal_types
        }
    
    def test_edge_cases(self):
        """Test edge cases and error conditions"""
        print("Testing edge cases...")
        
        # Test very short signals
        short_signal, fs = generate_white_noise(50, fs=1000)
        try:
            results = yasir_acw.calc_int(short_signal, fs)
            print(f"  Short signal (50 samples): Success, tau={results[4]:.4f}")
        except Exception as e:
            print(f"  Short signal (50 samples): Failed with {e}")
        
        # Test constant signal
        constant_signal = np.ones(1000)
        try:
            results = yasir_acw.calc_int(constant_signal, fs=1000)
            print(f"  Constant signal: ACW_50={results[0]:.4f}, tau={results[4]:.4f}")
        except Exception as e:
            print(f"  Constant signal: Failed with {e}")
        
        # Test signal with NaN values
        nan_signal, fs = generate_white_noise(1000, fs=1000)
        nan_signal[100:110] = np.nan
        try:
            results = yasir_acw.calc_int(nan_signal, fs)
            print(f"  Signal with NaN: tau={results[4]:.4f}")
        except Exception as e:
            print(f"  Signal with NaN: Failed with {e}")
        
        # Test extremely noisy signal
        noise_signal = np.random.randn(1000) * 1000
        try:
            results = yasir_acw.calc_int(noise_signal, fs=1000)
            print(f"  Extremely noisy signal: tau={results[4]:.4f}")
        except Exception as e:
            print(f"  Extremely noisy signal: Failed with {e}")
    
    def test_exponential_fitting_accuracy(self):
        """Test exponential fitting accuracy with synthetic exponential decay"""
        print("Testing exponential fitting accuracy...")
        
        tau_values = [0.05, 0.1, 0.2, 0.5]
        fs = 1000
        n_samples = 2000
        
        for true_tau in tau_values:
            # Generate pure exponential decay
            signal_data, _ = generate_exponential_decay(n_samples, tau=true_tau, fs=fs, A=1.0, B=0.0)
            
            # Add small amount of noise to make it realistic
            np.random.seed(42)
            signal_data += np.random.randn(n_samples) * 0.01
            
            acw_50, acw_0, acw_integral, acw_1_over_e, tau_fitted = yasir_acw.calc_int(signal_data, fs)
            
            if not np.isnan(tau_fitted):
                error = abs(tau_fitted - true_tau) / true_tau
                print(f"  True tau={true_tau:.3f}, fitted tau={tau_fitted:.3f}, error={error:.2%}")
            else:
                print(f"  True tau={true_tau:.3f}, fitting failed")
        
    def plot_test_signals(self, save_plots=True):
        """Generate plots of test signals for visual inspection"""
        print("Generating test signal plots...")
        
        fig, axes = plt.subplots(2, 3, figsize=(15, 10))
        axes = axes.flatten()
        
        signals_to_plot = [
            ("White Noise", generate_white_noise(1000, fs=1000)),
            ("AR(1) φ=0.8", generate_ar1_process(1000, phi=0.8, fs=1000)),
            ("Sinusoidal 10Hz", generate_sinusoidal(1000, freq=10, fs=1000)),
            ("Step Function", generate_step_function(1000, fs=1000)),
            ("Exponential Decay τ=0.1", generate_exponential_decay(1000, tau=0.1, fs=1000)),
        ]
        
        for i, (title, (signal_data, fs)) in enumerate(signals_to_plot):
            if i < len(axes):
                t = np.arange(len(signal_data)) / fs
                axes[i].plot(t, signal_data)
                axes[i].set_title(title)
                axes[i].set_xlabel('Time (s)')
                axes[i].set_ylabel('Amplitude')
                axes[i].grid(True, alpha=0.3)
        
        # Remove empty subplot
        if len(signals_to_plot) < len(axes):
            axes[-1].remove()
        
        plt.tight_layout()
        if save_plots:
            plt.savefig('test_signals.png', dpi=150, bbox_inches='tight')
            print("  Saved test signals plot as 'test_signals.png'")
        plt.show()
    
    def run_all_tests(self, plot_signals=True):
        """Run all test suites"""
        print("="*60)
        print("RUNNING COMPREHENSIVE ACW ANALYSIS TESTS")
        print("="*60)
        
        try:
            self.test_white_noise()
            print()
            
            self.test_ar1_process()
            print()
            
            self.test_sinusoidal_signals()
            print()
            
            self.test_sampling_frequency_scaling()
            print()
            
            self.test_multichannel_processing()
            print()
            
            self.test_edge_cases()
            print()
            
            self.test_exponential_fitting_accuracy()
            print()
            
            if plot_signals:
                self.plot_test_signals()
            
            print("="*60)
            print("ALL TESTS COMPLETED SUCCESSFULLY")
            print("="*60)
            
        except Exception as e:
            print(f"Test failed with error: {e}")
            raise
        
        return self.test_results

def main():
    """Main function to run all tests"""
    tester = TestACWAnalysis()
    results = tester.run_all_tests(plot_signals=True)
    
    # Optionally save results
    import pickle
    with open('acw_test_results.pkl', 'wb') as f:
        pickle.dump(results, f)
    print("Test results saved to 'acw_test_results.pkl'")

if __name__ == "__main__":
    main()
